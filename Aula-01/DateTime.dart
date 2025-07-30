void main() {
  int informado = 5;
  int atual = DateTime.now().month;

  if (atual > informado) 
  {
    print('$atual é maior que $informado');
  } 

  else if (informado > atual) 
  {
    print('$informado é maior que $atual');
  } 
  
  else 
  {
    print('$atual é igual $informado');
  }
}
