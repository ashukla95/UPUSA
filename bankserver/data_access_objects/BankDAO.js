let mysql = require('mysql');

let con = mysql.createConnection({
	host: "localhost",
	user: "root",
	password: "root",
	database: "bank"
});

function performTransaction(account_number, amount){
	console.log("perfrom trans: ", account_number, amount);
	return new Promise((resolve, reject) => {
		let sql = `CALL perform_transaction(?,?)`;
		con.query(sql, [account_number, amount], (error, result, fields) => {
			if(error) {
				reject(error.message);
			}
			console.log("result: ", result[0]);
			return resolve(result[0]);
		});
	});
}

module.exports={
	performTransaction,
}
