
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Repeat extends StatelessWidget {
  const Repeat({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(onPressed: (){}, icon: Icon(Icons.add,),),
          SizedBox(
            width: size.width * 0.20,
            height: size.height * 0.05,
            child: FormBuilderTextField(
              maxLength: 4,
              style: Theme.of(context).textTheme.displaySmall,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                counterText: "",

                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)
                ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)
                  )
              ),


              name: 'Rounds',),
          ),
          IconButton(onPressed: (){}, icon: Icon(Icons.remove),),
        ],
      ),
    );
  }
}
