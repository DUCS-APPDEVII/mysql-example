const router = require("express").Router();
const conn = require("../mysqldb");

router.get('/',(req,res) => {
    // create the query
    let qry = "select uid, email, lname, fname, role, created from user;";

    // query the database
    conn.query(qry, (err, rows) => {
        if (err) return res.status(500).json({error: err});

        // assert: no error - process the result set
        if (rows.length == 0) {
            // no users found
            res.status(400).json({ msg: "No users found"});
          }
          else {
              // process the user records
              let users =[];
              rows.forEach((row) =>{
                  let user = {
                      uid: row.uid,
                      email: row.email,
                      lname: row.lname,
                      fname: row.fname,
                      role: row.role,
                      dateCreated: row.created
                    }
                    users.push(user);
              });
              res.status(200).json(users);
          }
    });
});

module.exports = router;