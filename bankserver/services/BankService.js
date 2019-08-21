module.exports = function (app) {

	let bankDao = require('../data_access_objects/BankDAO');

	function performTransaction(req, res) {
		let body = req.body;
		console.log("body: ", body);
		console.log("body received in transaction: ", req.body);
		console.log("body received in transaction1: ", body['account_number']);
		console.log("body received in transaction2: ", body["bill_amount"]);
		console.log("body received in transaction2: ",req.body.account_number);
		console.log("body received in transaction2: ", req.body.bill_amount);
		return bankDao.performTransaction(body['account_number'], body["bill_amount"])
			.then(response => {
				let resultTemp = {
					finalMessage: response[0]["finalMessage"]
				};
				console.log("bank service result: ", resultTemp);
				res.json(resultTemp);
			});
	}

	app.post("/api/bank/transaction/debit", performTransaction)
};
