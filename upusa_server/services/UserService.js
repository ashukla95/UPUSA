const fetch = require('node-fetch');
const axios = require('axios');
module.exports = function (app) {

	let userDao = require("../data_access_objects/UserDAO");

	function checkUserPresence(req, res) {
		userDao.checkUserPresence(req.body)
			.then(response => {
				return res.json(response);
			});
	}

	function registerUserFirstStage(req, res) {
		userDao.registerUserFirstStage(req.body)
			.then(response => {
				//console.log("response: ", response);
				return res.json(response);
			})
	}

	function getUserCurrentBills(req, res) {
		userDao.getUserCurrentBills(req.params["userName"]).then(response => {
			//console.log("response: ", response);
			return res.json(response);
		})
	}

	function getUserBillHistory(req, res) {
		userDao.getUserBillHistory(req.params["userName"]).then(response => {
			//console.log("response: ", response);
			return res.json(response);
		})
	}

	function getUserBankAccountInformation(req, res) {
		userDao.getUserBankAccountInformation(req.params["userName"]).then(response => {
			//console.log(" response: ", response);
			return res.json(response);
		})
	}

	function payBill(req, res) {
		//console.log("req body: ", req.body);
		//console.log("req body 1: ", req.body["account_number"]);
		//console.log("req body 2: ", req.body["bill_amount"]);
		axios.post("http://localhost:8081/api/bank/transaction/debit", req.body).then(response => {
			//console.log("result axios: ", response.data);
			//console.log("result axios 2: ", response.data["finalMessage"]);
			//console.log("req body: ", req.body);
			if (response.data["finalMessage"] === "Transaction Successful") {
				axios.post("http://localhost:8080/api/bill-deactivate", {
					billId: req.body["billId"]
				}).then(response => {/*console.log("res[ponse: ", response.data)*/; res.json(response.data)});
			} else {
				return res.json(response.data)
			}
		});

	}

	function getBillData(req, res) {
		userDao.getBillData(req.params["billId"]).then(response => {
			return res.json(response);
		})
	}

	function insertBill(req, res) {
		userDao.insertBill(req.body).then(response => {
			return res.json(response);
		})
	}

	function removeCurrentBill(req, res) {
		userDao.removeCurrentBill(req.body).then(response => {
			//console.log("response remove current bill: ", response)
			return res.json(response[0]);
		})
	}

	app.post("/api/checkUser", checkUserPresence);
	app.post("/api/registerUserInitial", registerUserFirstStage);
	app.get("/api/get-user-current-bills/:userName", getUserCurrentBills);
	app.get("/api/get-user-bill-history/:userName", getUserBillHistory);
	app.get("/api/get/user-bank-account-information/:userName", getUserBankAccountInformation);
	app.get("/api/get-bill-data/:billId", getBillData);
	app.post("/api/pay-bill", payBill);
	app.post("/api/insert-bill", insertBill);
	app.post("/api/bill-deactivate", removeCurrentBill);
};
