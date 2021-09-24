
import 'package:animate_do/animate_do.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class Dashboard_site extends StatefulWidget {

  Dashboard_site();

  @override
  Dashboard_siteState createState() => Dashboard_siteState();

}

class Dashboard_siteState extends State<Dashboard_site> {

  Dashboard_siteState();

  TextEditingController controller_medicamento = TextEditingController();
  TextEditingController controller_promociones = TextEditingController();
  var Medicamentos = List<Widget>();
  var MedicamentosTemp = List<Widget>();
  var Promociones = List<Widget>();
  var PromocionesTemp = List<Widget>();
  var Facturas = List<Widget>();
  var FacturasTemp = List<Widget>();

  void consultarMedicamentos() async{
    try {
      var response = await Dio().get('http://localhost:9092/v1/medicamento');
      for(var iten in response.data){
        MedicamentosTemp.add(Container(
          child: Wrap(
            alignment: WrapAlignment.start,
            children: <Widget>[
              Divider(),
              Container(
                child: Text("Id°: "+iten['id'].toString()+" ",style: TextStyle(fontSize: 18),)
              ),
              Container(
                  child: Text(iten['nombre']+" c/u "+iten['precio'].toString(),style: TextStyle(fontSize: 18),)
              ),
            ],
          )
        ));
      }
      setState(() {
        Medicamentos=MedicamentosTemp;
      });
    } catch (e) {
      print(e);
    }
  }

  void consultarPromociones() async{
    try {
      var response = await Dio().get('http://localhost:9092/v1/promocion');
      for(var iten in response.data){
        PromocionesTemp.add(Container(
            child: Wrap(
              alignment: WrapAlignment.start,
              children: <Widget>[
                Divider(),
                Container(
                    child: Text("Id°: "+iten['id'].toString()+" ",style: TextStyle(fontSize: 18),)
                ),
                Container(
                    child: Text(iten['porcentaje'].toString()+"% "+iten['descripcion'].toString(),style: TextStyle(fontSize: 18),)
                ),
              ],
            )
        ));
      }
      setState(() {
        Promociones=PromocionesTemp;
      });
    } catch (e) {
      print(e);
    }
  }
  
  void consultarFacturasPorFecha(DateTime currentDate, DateTime currentDate2) async{
    try {
      String Date1 = DateFormat('yyyy-MM-dd').format(currentDate);
      String Date2 = DateFormat('yyyy-MM-dd').format(currentDate2);
      if(currentDate.millisecondsSinceEpoch < currentDate2.millisecondsSinceEpoch) {
        var response = await Dio().get(
            'http://localhost:9092/v1/factura?fecha_inicio=' + Date1 +
                '&fecha_fin=' + Date2);
        for (var iten in response.data) {
          var listaMedicamentosFacturados = List<Widget>();
          for (var medicamentos in iten['medicamentos']){
            listaMedicamentosFacturados.add(Container(

            ));
          }
          FacturasTemp.add(Container(
              child: Wrap(
                alignment: WrapAlignment.start,
                children: <Widget>[
                  Divider(),
                  Container(
                      child: Text("Id°: " + iten['id'].toString() + " ",
                        style: TextStyle(fontSize: 18),)
                  ),
                  Container(
                      child: Text(iten['fecha_crear'].toString() + " " +iten['pago_total'].toString(),style: TextStyle(fontSize: 18),)
                  ),
                  Container(
                      child: Column(
                        children: listaMedicamentosFacturados,
                      )
                  ),
                ],
              )
          ));
        }
        setState(() {
          Facturas = FacturasTemp;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void consultarFacturas() async{
    try {
      var response = await Dio().get('http://localhost:9092/v1/promocion');
      for(var iten in response.data){
        PromocionesTemp.add(Container(
            child: Wrap(
              alignment: WrapAlignment.start,
              children: <Widget>[
                Container(
                    child: Text("Id°: "+iten['id'].toString()+" ",style: TextStyle(fontSize: 18),)
                ),
                Container(
                    child: Text(iten['porcentaje'].toString()+"% "+iten['descripcion'].toString(),style: TextStyle(fontSize: 18),)
                ),
              ],
            )
        ));
      }
      setState(() {
        Promociones=PromocionesTemp;
      });
    } catch (e) {
      print(e);
    }
  }

  DateTime currentDate = DateTime.now();
  DateTime currentDate2 = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {

    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1999),
        lastDate: DateTime(2050));

    if(currentDate == DateTime.now() && pickedDate != null) {
      setState(() {
        currentDate = pickedDate;
      });
      _selectDate(context);
    }else if(currentDate2 == DateTime.now() && pickedDate != null){
      setState(() {
        currentDate2 = pickedDate;
      });
      consultarFacturasPorFecha(currentDate,currentDate2);
    }
  }

  @override
  void initState() {
    consultarMedicamentos();
    consultarPromociones();
    consultarFacturas();
  }

  void changeMedicamento(String medicamento){

  }

  void changePromocion(String promocion){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Material(
          child: Container(
             height: MediaQuery.of(context).size.height,
             width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.all(8),
                        child: Card(
                          elevation: 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.only(top: 16),
                                      child: Text("Buscar medicamento", style: TextStyle(fontSize: 23),)
                                  ),
                                  Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width / 2.2,
                                      child: Container(
                                        padding: EdgeInsets.all(9),
                                        margin: EdgeInsets.all(8),
                                        child: TextField(
                                          controller: controller_medicamento,
                                          style: TextStyle(fontSize: 19),
                                          onChanged: (v){
                                            changeMedicamento(v);
                                          },
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(bottom: 16,top: 16),
                                              prefixIcon: Icon(Icons.search, size: 14,)
                                          ),
                                        ),
                                      )
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.only(top: 16),
                                      child: Text("Buscar promoción", style: TextStyle(fontSize: 23),)
                                  ),
                                  Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width / 2.2,
                                      child: Container(
                                        padding: EdgeInsets.all(9),
                                        margin: EdgeInsets.all(8),
                                        child: TextField(
                                          controller: controller_promociones,
                                          style: TextStyle(fontSize: 19),
                                          onChanged: (v){
                                            changePromocion(v);
                                          },
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(bottom: 16,top: 16),
                                              prefixIcon: Icon(Icons.search, size: 14,)
                                          ),
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                    ),
                    Container(
                        margin: EdgeInsets.all(8),
                        child: Card(
                          elevation: 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(8),
                                color: Colors.red,
                                height: MediaQuery.of(context).size.height / 1.5,
                                width: MediaQuery.of(context).size.width / 2.2,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(top: 16),
                                      child: Text("Medicamentos", style: TextStyle(fontSize: 23),)
                                    ),
                                    SingleChildScrollView(
                                      child: Column(
                                        children: Medicamentos,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        width: MediaQuery.of(context).size.width / 2.2,
                                        height: MediaQuery.of(context).size.height / 3,
                                        color: Colors.green,
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                                margin: EdgeInsets.only(top: 16),
                                                child: Text("Promociones", style: TextStyle(fontSize: 23),)
                                            ),
                                            Column(
                                              children: Promociones,
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        width: MediaQuery.of(context).size.width / 2.2,
                                        height: MediaQuery.of(context).size.height / 3,
                                        color: Colors.teal,
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                    margin: EdgeInsets.only(top: 16),
                                                    child: Text("Facturas", style: TextStyle(fontSize: 23),)
                                                ),
                                                InkWell(
                                                    onTap: (){
                                                      _selectDate(context);
                                                    },
                                                    child:Container(
                                                        child:Icon(Icons.access_time)
                                                    )
                                                )
                                              ],
                                            ),
                                            Column(
                                              children: Facturas,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                              )
                            ],
                          ),
                        )
                    ),
                    Container(
                      margin: EdgeInsets.all(8),
                      child: Container(
                        width: 320,
                        alignment: Alignment.bottomRight,
                        child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.redAccent
                                      ),
                                      onPressed: () {  },
                                      child: Text("Facturar",style: TextStyle(fontSize: 23)),
                                    )
                                ),
                                Container(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.blueAccent
                                      ),
                                      onPressed: () {  },
                                      child: Text("Simular",style: TextStyle(fontSize: 23)),
                                    )
                                ),
                              ],
                            )
                        ),
                      )
                    )
                  ],
                ),
              )
          ),
        )
    );
  }
}