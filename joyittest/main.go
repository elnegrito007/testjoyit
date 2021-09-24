package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"github.com/go-chi/chi"
	"github.com/go-chi/cors"
	"github.com/joho/godotenv"
	"github.com/lib/pq"
	_ "github.com/lib/pq"
	"log"
	"net/http"
	"os"
	"strconv"
	"strings"
)

type Medicamento struct {
	Id int32 `json:"id"`
	Nombre string `json:"nombre"`
	Precio float32 `json:"precio"`
	Ubicacion string `json:"ubicacion"`
}

type Promocion struct {
	Id int32 `json:"id"`
	Descripcion string `json:"descripcion"`
	Porcentaje float32 `json:"porcentaje"`
	Fecha_inicio string `json:"fecha_inicio"`
	Fecha_fin string `json:"fecha_fin"`
}

type Facturapost struct {
	Fecha_inicio string `json:"fecha_inicio"`
	Fecha_fin string `json:"fecha_fin"`
}

type Factura struct {
	Id int32 `json:"id"`
	Fecha_crear string `json:"fecha_crear"`
	Pago_total float32 `json:"pago_total"`
	Id_promocion int32 `json:"id_promocion"`
	Id_medicamentos []int32 `json:"id_medicamentos"`
}

var (
	id int32
	nombre string
	precio float32
	ubicacion string
	descripcion string
	porcentaje float32
	fecha_inicio string
	fecha_fin string
	fecha_crear string
	pago_total string
	id_promocion int32
	id_medicamentos []int32
	id_medicamentos_pg pq.Int32Array
)

var db *sql.DB

func init() {
	tmpDB, err := sql.Open("postgres", "postgres://dorlxrfa:gzC3iqOBRJ-MbM-PnJpWO7-sqiVvwlq2@drona.db.elephantsql.com/dorlxrfa")
	if err != nil {
		log.Fatal(err)
	}
	db = tmpDB

	_, _ = db.Exec(`CREATE TABLE IF NOT EXISTS medicamento(id SERIAL NOT NULL,nombre VARCHAR NOT NULL,precio FLOAT NOT NULL,ubicacion VARCHAR NOT NULL);`)
	_, _ = db.Exec(`CREATE TABLE IF NOT EXISTS promocion(id SERIAL NOT NULL,descripcion VARCHAR NOT NULL,porcentaje FLOAT NOT NULL,fecha_inicio VARCHAR NOT NULL,fecha_fin VARCHAR NOT NULL);`)
	_, _ = db.Exec(`CREATE TABLE IF NOT EXISTS facturapost(id SERIAL NOT NULL,fecha_crear VARCHAR NOT NULL,pago_total FLOAT NOT NULL,id_promocion INTEGER NOT NULL,id_medicamentos integer[]);`)
}

func main() {
	_ = godotenv.Load(".env")
	_ = http.ListenAndServe(":"+os.Getenv("PORT"), router_credit_assignment())
}

func router_credit_assignment() http.Handler {
	r := chi.NewRouter()
	cors2 := cors.New(cors.Options{
		AllowedOrigins:   []string{"*"},
		AllowedMethods:   []string{"POST","GET"},
		AllowedHeaders:   []string{"Accept", "Authorization", "Content-Type"},
		ExposedHeaders:   []string{"Link"},
		AllowCredentials: true,
		MaxAge:           300,
	})
	r.Use(cors2.Handler)
	r.Route("/v1", func(r chi.Router) {
		r.Group(func(r chi.Router) {
			r.Post("/medicamento", func(w http.ResponseWriter, r *http.Request) {
				decoder := json.NewDecoder(r.Body)
				var t Medicamento
				err := decoder.Decode(&t)
				if err != nil {
					panic(err)
				}
				_, err = db.Exec(`INSERT INTO medicamento(id,nombre,precio,ubicacion) VALUES ($1, $2, $3, $4)`,int(t.Id),t.Nombre,fmt.Sprintf("%f", t.Precio),t.Ubicacion)
				if err == nil {
					_, _ = w.Write([]byte(`"medicamento creado"`))
				}else{
					w.WriteHeader(http.StatusBadRequest)
					_, _ = w.Write([]byte(`"medicamento no creado"`))
				}
			})
			r.Get("/medicamento", func(w http.ResponseWriter, r *http.Request) {
				rows, err := db.Query("SELECT * FROM medicamento")
				if err != nil {
					panic(err)
				}
				defer rows.Close()
				arrays :=""
				for rows.Next() {
					err := rows.Scan(&id, &nombre, &precio, &ubicacion)
					if err != nil {
						panic(err)
					}
					arrays += `{"id":`+strconv.Itoa(int(id))+`,"nombre":"`+nombre+`","precio":`+fmt.Sprintf("%f", precio)+`,"ubicacion":"`+ubicacion+`"},`
				}
				if len(arrays) > 0 { arrays = arrays[:len(arrays)-1] }
				w.Header().Set("Content-Type", "application/json")
				_,_ = w.Write([]byte(`[`+arrays+`]`))
			})
			r.Post("/promocion", func(w http.ResponseWriter, r *http.Request) {
				decoder := json.NewDecoder(r.Body)
				var t Promocion
				err := decoder.Decode(&t)
				if err != nil {
					panic(err)
				}
				_, err = db.Exec(`INSERT INTO promocion(id,descripcion,porcentaje,fecha_inicio,fecha_fin) VALUES ($1, $2, $3, $4, $5)`,int(t.Id),t.Descripcion,fmt.Sprintf("%f", t.Porcentaje),t.Fecha_inicio,t.Fecha_fin)
				if err == nil {
					_, _ = w.Write([]byte(`"promocion creado"`))
				}else{
					w.WriteHeader(http.StatusBadRequest)
					_, _ = w.Write([]byte(`"promocion no creado"`))
				}
			})
			r.Get("/promocion", func(w http.ResponseWriter, r *http.Request) {
				rows, err := db.Query("SELECT * FROM promocion")
				if err != nil {
					panic(err)
				}
				defer rows.Close()
				arrays :=""
				for rows.Next() {
					err := rows.Scan(&id, &descripcion, &porcentaje, &fecha_inicio, &fecha_fin)
					if err != nil {
						panic(err)
					}
					arrays += `{"id":`+strconv.Itoa(int(id))+`,"descripcion":"`+descripcion+`","porcentaje":`+fmt.Sprintf("%f", porcentaje)+`,"fecha_inicio":"`+fecha_inicio+`","fecha_fin":"`+fecha_fin+`"},`
				}
				if len(arrays) > 0 { arrays = arrays[:len(arrays)-1] }
				w.Header().Set("Content-Type", "application/json")
				_,_ = w.Write([]byte(`[`+arrays+`]`))
			})
			r.Post("/factura", func(w http.ResponseWriter, r *http.Request) {
				decoder := json.NewDecoder(r.Body)
				var t Factura
				err := decoder.Decode(&t)
				if err != nil {
					panic(err)
				}
				_, err = db.Exec(`INSERT INTO facturapost(id,fecha_crear,pago_total,id_promocion,id_medicamentos) VALUES ($1, $2, $3, $4, $5)`,int(t.Id),t.Fecha_crear,fmt.Sprintf("%f", t.Pago_total),t.Id_promocion,pq.Array(t.Id_medicamentos))
				if err == nil {
					_, _ = w.Write([]byte(`"factura creada"`))
				}else{
					fmt.Println(err)
					w.WriteHeader(http.StatusBadRequest)
					_, _ = w.Write([]byte(`"factura no creado"`))
				}
			})
			r.Get("/factura", func(w http.ResponseWriter, r *http.Request) {
				fecha_inicio := r.URL.Query().Get("fecha_inicio")
				fecha_fin := r.URL.Query().Get("fecha_fin")
				rows, err := db.Query(`SELECT * FROM facturapost WHERE fecha_crear between date('`+fecha_inicio+`') AND date('`+fecha_fin+`');`)
				if err != nil {
					panic(err)
				}
				defer rows.Close()
				arrays :=""
				for rows.Next() {
					err := rows.Scan(&id, &fecha_crear, &pago_total, &id_promocion, &id_medicamentos_pg)
					if err != nil {
						panic(err)
					}

					stringedIDs := fmt.Sprintf("%v", id_medicamentos_pg)
					stringedIDs = stringedIDs[1 : len(stringedIDs)-1]
					stringedIDs = strings.ReplaceAll(stringedIDs, " ", ",")
					arrays2 :=""
					rows2, err2 := db.Query(`select * from medicamento WHERE id IN (`+stringedIDs+`)`)
					if err2 != nil {
						panic(err)
					}
					defer rows2.Close()
					for rows2.Next() {
						err2 := rows2.Scan(&id, &nombre, &precio, &ubicacion)
						if err2 != nil {
							panic(err2)
						}
						arrays2 += `{"id":`+strconv.Itoa(int(id))+`,"nombre":"`+nombre+`","precio":`+fmt.Sprintf("%f", precio)+`,"ubicacion":"`+ubicacion+`"},`
					}
					if len(arrays2) > 0 { arrays2 = arrays2[:len(arrays2)-1] }
					arrays += `{"id":`+strconv.Itoa(int(id))+`,"fecha_crear":"`+fecha_crear+`","pago_total":`+pago_total+`,"id_promocion":"`+strconv.Itoa(int(id_promocion))+`","id_medicamentos":[`+arrays2+`]},`
				}
				if len(arrays) > 0 { arrays = arrays[:len(arrays)-1] }
				w.Header().Set("Content-Type", "application/json")
				_,_ = w.Write([]byte(`[`+arrays+`]`))
			})
			r.Get("/factura/simular", func(w http.ResponseWriter, r *http.Request) {
				fecha_compra := r.URL.Query().Get("fecha_compra")
				id_medicamentos := r.URL.Query().Get("id_medicamentos")
				rows, err := db.Query(`SELECT porcentaje,precio FROM promocion INNER JOIN medicamento ON medicamento.id=`+id_medicamentos+` WHERE fecha_fin > '`+fecha_compra+`' ;`)
				if err != nil {
					panic(err)
				}
				defer rows.Close()
				for rows.Next() {
					err := rows.Scan(&precio, &porcentaje)
					if err != nil {
						panic(err)
					}
					var result = precio * porcentaje
					w.Header().Set("Content-Type", "application/json")
					_,_ = w.Write([]byte(``+strconv.Itoa(int(result))+``))
				}
			})
		})
	})
	return r
}