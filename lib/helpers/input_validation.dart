class InputValidation {
  static String? validateInput(String? value) {
    if(value!.isEmpty) {
      return "Preencha os campos";
    } else if ((int.tryParse(value) != null)) 
    {
      int inputReturn = int.tryParse(value)!.toInt();
      if(inputReturn <= 0){
        return "O total não pode ser zero";
      }else if(inputReturn > 1000){
        return "O total tem que ser menor que 1000 unidades";
      }
    }
    return null;
  }
}
