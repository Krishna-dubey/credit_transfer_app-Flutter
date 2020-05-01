import 'package:credittransferapp/screens/Transaction/ModelForTransaction.dart';
import 'package:flutter/material.dart';
class RowForHistory extends StatelessWidget {
  ModelForTransaction data;

  RowForHistory(this.data);

   Icon getIcon(type){
    if(type=="to"){
      return Icon(Icons.arrow_upward);
    }else{
      return Icon(Icons.arrow_downward);
    }
  }

  @override
  Widget build(BuildContext context) {
    if(data == null) return Center(child: CircularProgressIndicator());
    return Card(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: getIcon(data.type),
              )
          ),
          Expanded(
            flex: 9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0,8.0,0.8,0.0),
                  child: Text(
                      data.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        flex:5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              data.credits,
                            style: TextStyle(
                              fontSize: 15
                            ),
                          ),
                        )),
                    Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              child: Text(
                                  data.dateAndTime ?? " ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 10
                                ),
                              ),
                            ),
                          ),
                        ))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
