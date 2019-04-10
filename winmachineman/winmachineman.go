package main

import (
	"net/http"
	"github.com/go-chi/chi"
        "github.com/go-chi/chi/middleware"
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



// Install a New Machine
func CreateMachine(w http.ResponseWriter, r *http.Request) { 
    log.Printf("CreateMachine: %s\n",r.Body,)
    if err := r.ParseForm(); err != nil {
            log.Printf("ParseForm() err: %v", err)
            } else {
             log.Printf("Post from website! r.PostFrom = %v\n", r.PostForm)
            }
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

