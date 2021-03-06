let express = require('express');
let app = express();
let bodyParser = require('body-parser');
app.use(function (req, res, next) {
	res.header("Access-Control-Allow-Origin", "*");
	res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
	res.header("Access-Control-Allow-Methods", "GET,POST,PUSH,DELETE,OPTIONS");
	res.header("Access-Control-Allow-Credentials", "true");
	next();
});
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: true}));
require("./services/BankService")(app);
console.log("Starting the server.");
app.listen(8081);
console.log("Server active and running.");

