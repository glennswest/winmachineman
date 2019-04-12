package main

import (
	"net/http"
        "io"
	"io/ioutil"
	"github.com/go-chi/chi"
        "github.com/go-chi/chi/middleware"
        "github.com/tidwall/gjson"
        "strings"
         "encoding/json"
         "fmt"
         "log"
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


func MachineCreate(hostname string,data string) {

    log.Printf("CreateMachine: %s\n",hostname)

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
	http.ListenAndServe(":8080", r)
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

