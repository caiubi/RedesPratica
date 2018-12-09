const readline = require('readline');
const fs = require('fs');

try{
	routes = require('./camada_rede/routes.json');
}catch(ex){
	routes = [];
}

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});


// console.log()
switch(process.argv[2]){
	case 'add':
			rl.question("Digite o ip de rede, mascara e ip de destino separados por espaço: ", (answer) => {
				  let routesPart = answer.split(" ");
				  routes.push({
				  	networkIp: routesPart[0],
				  	mask: routesPart[1],
				  	nextHop: routesPart[2]
				  });

				  fs.writeFile("./camada_rede/routes.json", JSON.stringify(routes), function(err) {
				    if(err) {
				        return console.log(err);
				    }

				    console.log("Salvo!");
				}); 


				rl.close();
			});
		break;
	case 'delete-all':
		fs.unlink("./camada_rede/routes.json");
		console.log("Dados apagados!");
		rl.close();
		break;
	case 'list':
		console.log(routes);
		rl.close();
		break;
	default:
		console.log("Digite uma opçao valida. Ex: add delete-all list");
		rl.close();
}
