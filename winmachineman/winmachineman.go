package main

import (
	"net/http"
        "io"
	"io/ioutil"
	"github.com/go-chi/chi"
        "github.com/go-chi/chi/middleware"
        "github.com/tidwall/sjson"
        "github.com/tidwall/gjson"
        "github.com/glennswest/libpowershell/pshell"
        "strings"
         "os"
         "encoding/json"
         "fmt"
         "log"
         "bytes"
)

var router *chi.Mux

func routers() *chi.Mux {
     router.Post("/machines", CreateMachine)
     router.Delete("/machines/{id}", DeleteMachine)
     router.Put("/machines/{id}", UpdateMachine)
     router.Get("/machines",AllMachines)
     router.Get("/healthz",ReadyCheck)
     router.Get("/alivez", AliveCheck)
     router.Get("/", HumanUI)

     return(router)
}

func init() { 
    router = chi.NewRouter() 
    router.Use(middleware.Recoverer)  
    router.Use(middleware.RequestID)
    router.Use(middleware.Logger)
    router.Use(middleware.Recoverer)
    router.Use(middleware.URLFormat)
}

func ReadyCheck(w http.ResponseWriter, r *http.Request) { 
    log.Printf("ReadyCheck %s\n", r.Body)
    respondwithJSON(w, http.StatusOK, map[string]string{"message": "ready"})
}

func AliveCheck(w http.ResponseWriter, r *http.Request) { 
    log.Printf("ReadyCheck %s\n", r.Body)
    respondwithJSON(w, http.StatusOK, map[string]string{"message": "alive"})
}

func AllMachines(w http.ResponseWriter, r *http.Request) { 
    log.Printf("AllMachines %s\n", r.Body)
    respondwithJSON(w, http.StatusOK, map[string]string{"message": "ok"})
}

func HumanUI(w http.ResponseWriter, r *http.Request) { 
    log.Printf("HumanUI %s\n", r.Body)
    respondwithJSON(w, http.StatusOK, map[string]string{"message": "ok"})
}

func GetTemplateName(winversion string) string {
     // win10.0.17763.template
     tpath := "/templates/win" + winversion + ".template"
     if (Exists(tpath)){
        return(tpath)
        }
     tpath = "/templates/windefault.template"
     return(tpath)
}

func MachineCreate(hostname string,data string) {

    // Add my url to data before sending it to host
    myurl := os.Getenv("MYURL")
    log.Printf("MyURL = %s\n",myurl)
    data = ArAdd(data,"settings","wmmurl",myurl)

    log.Printf("CreateMachine: %s\n",hostname)
    os.MkdirAll("/data/" + hostname,0700)
    username := GetSetting(data,"user")
    password := GetSetting(data,"password")
    hostip   := GetAnnotation(data,"host/ip")
    //log.Printf("Username: %s Password: %s\n:",username,password)
    pshell.SetRemoteMode(hostip,username,password)
    version := pshell.GetWinVersion()
    if (version == ""){
       log.Printf("Node: %s(%s) not accessable - install aborted\n",hostname,hostip)
       return
       } 
    log.Printf("Version:  %s\n",version)
    result := pshell.Powershell("Test-Path -Path \"/Program` Files/WindowsNodeManager/winnodeman.exe\"")
    if (result == "true"){
       log.Printf("Stopping existing winnodeman service\n")
       pshell.Powershell("/Program` Files/WindowsNodeManager/winnodeman.exe stop")
       pshell.Powershell("/Program` Files/WindowsNodeManager/winnodeman.exe uninstall")
       } else {
       log.Printf("Installing New winnodeman service\n")
       pshell.Powershell("mkdir /Program` Files/WindowsNodeManager")
       pshell.Powershell("netsh advfirewall firewall add rule name=\"WinNodeManager Interface tcp 8951\" dir=in action=allow protocol=TCP localport=8951")
       }
    cmd := "curl " + "http://" + myurl + "/content/winnodeman.exe -o " + "/Program` Files/WindowsNodeManager/winnodeman.exe"
    pshell.Powershell(cmd)
    pshell.Powershell("/Program` Files/WindowsNodeManager/winnodeman.exe install")
    pshell.Powershell("/Program` Files/WindowsNodeManager/winnodeman.exe start")
    
    template := GetTemplateName(version)
    log.Printf("Using Template: %s\n",template)
    data = ArAdd(data,"settings","template",template)
    // Need to pass the guid from winoperator -- Hardcode for now
    wmmurl := "http://" + hostip + ":8951/node/install/11111111"
    resp, err := http.Post(wmmurl,"application/json", bytes.NewBuffer([]byte(data)))
    log.Printf("Response = %s %s\n",resp,err)


}

// Install a New Machine
// {"settings":[{"user","Administrator"},{"password","SuperLamb931"}],"version": 1, "labels": [{"beta.kubernetes.io/arch","amd64"},{"beta.kubernetes.io/os","windows"},{"kubernetes.io/hostname","winnode01"},{"node-role.kubernetes.io/compute","true"}], "annotations": [{"ovn_host_subnet","10.128.1.0/24"},{"volumes.kubernetes.io/controller-managed-attach-detach","true"}]}
func CreateMachine(w http.ResponseWriter, r *http.Request) { 
    log.Printf("CreateMachine: %s\n",r.Body,)
        body, err := ioutil.ReadAll(io.LimitReader(r.Body, 1048576))
	if err != nil {
		panic(err)
	}
	if err := r.Body.Close(); err != nil {
		panic(err)
	}
    v := string(body)
    log.Printf("JSON: %s\n",v)
    hostname := GetLabel(v,`kubernetes\.io/hostname`)
    go MachineCreate(hostname, v)
    respondwithJSON(w, http.StatusCreated, map[string]string{"message": "successfully created"})
}

// UpdateMachine update a specific machine
func UpdateMachine(w http.ResponseWriter, r *http.Request) {
    id := chi.URLParam(r, "id")
    log.Printf("Update Machine: id: %s - %s\n", id, r.Body)
    respondwithJSON(w, http.StatusOK, map[string]string{"message": "update successfully"})

}

// DeleteMachine - Uninstall a node
func DeleteMachine(w http.ResponseWriter, r *http.Request) {
    id := chi.URLParam(r, "id")
    log.Printf("Uninstall Machine: id:%s %s\n", id, r.Body)
    respondwithJSON(w, http.StatusOK, map[string]string{"message": "update successfully"})

}

func main() {
        r := routers()
        FileServer(r, "/templates", http.Dir("/templates"))
        FileServer(r, "/content", http.Dir("/content"))
	http.ListenAndServe(":8080", r)
}

// FileServer conveniently sets up a http.FileServer handler to serve
// static files from a http.FileSystem.
func FileServer(r chi.Router, path string, root http.FileSystem) {
	if strings.ContainsAny(path, "{}*") {
		panic("FileServer does not permit URL parameters.")
	}

	fs := http.StripPrefix(path, http.FileServer(root))

	if path != "/" && path[len(path)-1] != '/' {
		r.Get(path, http.RedirectHandler(path+"/", 301).ServeHTTP)
		path += "/"
	}
	path += "*"

	r.Get(path, http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		fs.ServeHTTP(w, r)
	}))
}
// respondwithError return error message
func respondWithError(w http.ResponseWriter, code int, msg string) {
    respondwithJSON(w, code, map[string]string{"message": msg})
}

// respondwithJSON write json response format
func respondwithJSON(w http.ResponseWriter, code int, payload interface{}) {
    response, _ := json.Marshal(payload)
    fmt.Println(payload)
    w.Header().Set("Content-Type", "application/json")
    w.WriteHeader(code)
    w.Write(response)
}


func GetLabel(v string,l string) string{
    result := gjson.Get(v,"labels.#." + l)
    x := result.String()
    x = strings.Replace(x, "[", "", -1)
    x = strings.Replace(x, "]", "", -1)
    x = strings.Replace(x, `"`, "", -1)
    return x
}
 
func GetAnnotation(v string,l string) string{
    result := gjson.Get(v,"annotations.#." + l)
    x := result.String()
    x = strings.Replace(x, "[", "", -1)
    x = strings.Replace(x, "]", "", -1)
    x = strings.Replace(x, `"`, "", -1)
    return x
}

func GetSetting(v string,l string) string{
    result := gjson.Get(v,"settings.#." + l)
    x := result.String()
    x = strings.Replace(x, "[", "", -1)
    x = strings.Replace(x, "]", "", -1)
    x = strings.Replace(x, `"`, "", -1)
    return x
}

func ArAdd(d string,aname string,v1 string,v2 string) string{
      s := `{"` + v1 + `":"` + v2 + `"}`
      a := aname + ".-1"
      d,_ = sjson.SetRaw(d,a,s)
      return d
      }

// Exists reports whether the named file or directory exists.
func Exists(name string) bool {
    if _, err := os.Stat(name); err != nil {
        if os.IsNotExist(err) {
            return false
        }
    }
    return true
}

