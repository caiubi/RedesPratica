// console.log(JSON.stringify(process.argv));


function isIpInMask(ip, networkIp, mask){
	let splittedMask = mask.split('.');
	let splittedIp = ip.split('.');
	let targetNetwork = [];
	for(i = 0; i < splittedIp.length; i++){
		targetNetwork.push(Number(splittedIp[i]) & Number(splittedMask[i]))
	}

	// console.log(targetNetwork.join(".")+" vs "+networkIp);
	return targetNetwork.join(".") == networkIp;
}

function getNextHop(ipRoutes, destIp){
	let result = -1;
	for (let i = 0; i < ipRoutes.length; i++) {
		if(isIpInMask(destIp, ipRoutes[i].networkIp, ipRoutes[i].mask)){
			result = i;
			break;
		}
	}

	return result;
}

function forwardPacketToInteface(ipRoutes, index, packetPath){
	console.log(index);
	let newDestinationIP = ipRoutes[index].nextHop;

	console.log("Will forward packet ["+packetPath+"] to destinationIP ["+newDestinationIP+"]");
}

function forwardPacketToLocalHost(packetPath){
	console.log("Will forward packet to local host.")
}

let packetPath = process.argv[2];
let destinationIP = process.argv[3];

try{
 routes = require('./routes.json');
 // routes = JSON.parse(routes);	
}catch(ex){
	routes = [];
}

let nextHopIndex = getNextHop(routes, destinationIP);

if(nextHopIndex != -1){
	forwardPacketToInteface(routes, nextHopIndex, packetPath);

}else{
	forwardPacketToLocalHost(packetPath);
}