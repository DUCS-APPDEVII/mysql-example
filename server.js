const express = require("express");
const config = require("./configuration/config.json");

// application constants
const PORT = config.serverPort;

// create the http app
const app = express();

// add a router
const router = express.Router();

// create API routes
router.use("/api/get-users", require("./api/get-users"));

// use the router in the app
app.use(router);

app.listen(PORT, (err) => {
    if (err) 
        console.log("Server startup failed.");
    else
        console.log(`Server listening on port ${PORT}`);
});