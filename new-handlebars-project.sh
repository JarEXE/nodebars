#!/bin/bash
# Function to check if node installed
check_node() {
  if ! command -v node &>/dev/null; then
    echo -e "\e[31mNode.js is not installed. Please install Node.js to proceed.\e[0m"
    echo -e "\e[31mVisit https://nodejs.org/en/download/ for instructions on how to install Node and the Node Package Manager.\e[0m"
    exit 1
  fi
}

# Run the Node.js check
check_node

# Get current date and time
current_date_time=$(date +"%Y%m%d_%H%M%S")
project_dir="my-node-server_$current_date_time"

# Create project directory and navigate into it
echo -e "\e[32mCreating project directory...\e[0m"
mkdir $project_dir
cd $project_dir

# Initialize the project
echo -e "\e[32minitializing npm project...\e[0m"
npm init -y

# Install Initial Packages
echo -e "\e[32minstalling required packages...\e[0m"
npm install express
echo -e "\e[32mexpress installed...\e[0m"
npm install nodemon
echo -e "\e[32mnodemon installed...\e[0m"
npm install dotenv
echo -e "\e[32mdotenv installed...\e[0m"
npm install body-parser
echo -e "\e[32mbody-parser installed...\e[0m"
npm install path
echo -e "\e[32mpath installed...\e[0m"
npm install express-handlebars
echo -e "\e[32mexpress-handlebars installed...\e[0m"
npm install express-session
echo -e "\e[32mexpress-session installled...\e[0m"
npm install express-flash
echo -e "\e[32mexpress-flash installed...\e[0m"
npm install axios
echo -e "\e[32maxios installed...\e[0m"

# Create public directory
echo -e "\e[32mCreating public directory...\e[0m"
mkdir public

# Create public subdirectories
cd public/
echo -e "\e[32mCreating assets directory...\e[0m"
mkdir assets

# Create temp styles
cd assets/
cat <<EOL >styles.css
body {
  background: beige;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 10%;
}
EOL
cd ..

echo -e "\e[32mCreating public helpers directory...\e[0m"
mkdir helpers
cd ..

# Copy axios JS to public assets directory
cp node_modules/axios/dist/axios.min.js public/assets/
npm remove axios

# Prompt user for bootstrap
display_options_bootstrap() {
  echo -e "\e[32mWould you like to include bootstrap in public directory? (1-2): \e[0m"
  echo -e "\e[32m1) Yes\e[0m"
  echo -e "\e[31m2) No\e[0m"
}

# Download and move Boostrap JS and CSS
valid_option_bootstrap=false
while [ "$valid_option_bootstrap" = false ]; do
  display_options_bootstrap
  read user_answer_bootstrap

  case $user_answer_bootstrap in
  1)
    npm install bootstrap
    cp node_modules/bootstrap/dist/js/boostrap.bundle.min.js public/assets/
    cp node_modules/bootstrap/dist/css/bootstrap.min.css public/assets/
    npm remove bootstrap
    valid_option_bootstrap=true
    ;;
  2)
    echo -e "\e[32mSkipping bootstrap...\e[0m"
    valid_option_bootstrap=true
    ;;
  *)
    echo -e "\e[33mInvalid option selected!\e[0m"
    ;;
  esac
done

# Prompt user for bootstrap
display_options_sweetalert2() {
  echo -e "\e[32mWould you like to include sweetalert2 in public directory? (1-2): \e[0m"
  echo -e "\e[32m1) Yes\e[0m"
  echo -e "\e[31m2) No\e[0m"
}

# Download and move sweetalert2 JS and CSS
valid_option_sweetalert2=false
while [ "$valid_option_sweetalert2" = false ]; do
  display_options_sweetalert2
  read user_answer_sweetalert2

  case $user_answer_sweetalert2 in
  1)
    npm install sweetalert2
    cp node_modules/sweetalert2/dist/sweetalert2.js public/assets/
    cp node_modules/sweetalert2/dist/sweetalert2.css public/assets/
    npm remove sweetalert2
    valid_option_sweetalert2=true
    ;;
  2)
    echo -e "\e[32mSkipping sweetalert2...\e[0m"
    valid_option_sweetalert2=true
    ;;
  *)
    echo -e "\e[33mInvalid option selected!\e[0m"
    ;;
  esac
done

# Create helper directory
echo -e "\e[32mcreating helpers directory...\e[0m"
mkdir helpers
cd helpers

# Create helper file
echo -e "\e[32mcreating handlebars helpers...\e[0m"
cat <<EOL >index.js
module.exports = {
  ifEquals: function (arg1, arg2, options) {
    return arg1 == arg2 ? options.fn(this) : options.inverse(this);
  },
  lookup: function (value, key, array, options) {
    for (let i = 0; i < array.length; i++) {
      if (array[i][key] == value) {
        return options.fn(array[i]);
      }
    }
  },
  ifvalue: function (val1, val2, options) {
    if (val1 === val2) {
      return options.fn(this);
    } else {
      return options.inverse(this);
    }
  },
  inc: function (value) {
    return parseInt(value) + 1;
  },
  json: function (context) {
    return JSON.stringify(context);
  },
  ifCond: function (v1, operator, v2, options) {
    switch (operator) {
      case "==":
        return v1 == v2 ? options.fn(this) : options.inverse(this);
      case "===":
        return v1 === v2 ? options.fn(this) : options.inverse(this);
      case "!=":
        return v1 != v2 ? options.fn(this) : options.inverse(this);
      case "!==":
        return v1 !== v2 ? options.fn(this) : options.inverse(this);
      case "<":
        return v1 < v2 ? options.fn(this) : options.inverse(this);
      case "<=":
        return v1 <= v2 ? options.fn(this) : options.inverse(this);
      case ">":
        return v1 > v2 ? options.fn(this) : options.inverse(this);
      case ">=":
        return v1 >= v2 ? options.fn(this) : options.inverse(this);
      case "&&":
        return v1 && v2 ? options.fn(this) : options.inverse(this);
      case "||":
        return v1 || v2 ? options.fn(this) : options.inverse(this);
      default:
        return options.inverse(this);
    }
  },
  numberFormat: function (value, options) {
    // Helper parameters
    var dl = options.hash["decimalLength"] || 2;
    //var ts = options.hash["thousandsSep"] || ",";
    var ds = options.hash["decimalSep"] || ".";

    // Parse to float
    var value = parseFloat(value);

    // The regex
    var re = "\\d(?=(\\d{3})+" + (dl > 0 ? "\\D" : "$") + ")";

    // Formats the number with the decimals
    var num = value.toFixed(Math.max(0, ~~dl));

    // Returns the formatted number
    return (ds ? num.replace(".", ds) : num).replace(new RegExp(re, "g"), "$&");
  },
  formatDate: function (date) {
    var formattedDate = new Date(
      date.replace(/-/g, "/").replace(/T.+/, "")
    ).toLocaleDateString("en-NL", {
      month: "2-digit",
      day: "2-digit",
      year: "numeric",
    });

    return formattedDate;
  },
  ifEmptyOrWhitespace: function (value, options) {
    if (!value) {
      return options.fn(this);
    }
    return value.replace(/\s*/g, "").length === 0
      ? options.fn(this)
      : options.inverse(this);
  },
  dateDiff: function (arg1, arg2, options) {
    let a = moment(arg1);
    let b = moment(arg2);
    return a.diff(b, "days");
  },
  isNull: function (value, options) {
    if (value === null) {
      return options.fn(this);
    } else {
      return options.inverse(this);
    }
  },
};
EOL
echo -e "\e[32mhelpers created...\e[0m"
cd ..

# Create routes directory
echo -e "\e[32mcreating routes directory...\e[0m"
mkdir routes
cd routes

# Create routes file
echo -e "\e[32mcreating pages.js for routes and setting initial root route...\e[0m"
cat <<EOL >pages.js
const express = require("express");
const router = express.Router();

router.get("/", (req, res) => {
  res.render("index", { layout: false });
});

module.exports = router;
EOL
echo -e "\e[32mroute created...\e[0m"
cd ..

# Create views directory
echo -e "\e[32mcreating views directory...\e[0m"
mkdir views
cd views

# Create tester home page
echo -e "\e[32mcreating default test view...\e[0m"
cat <<EOL >index.handlebars
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="/assets/sweetalert2.css" />
    <link rel="stylesheet" href="/assets/bootstrap.min.css" />
    <link rel="stylesheet" href="/assets/styles.css" />
    <title>Remote Printing</title>
  </head>
  <body>
    <h1>HELLO WORLD</h1>
    <script src="/assets/axios.min.js"></script>
    <script src="/assets/sweetalert2.js"></script>
    <script src="/assets/bootstrap.bundle.min.js"></script>
  </body>
</html>
EOL
echo -e "\e[32mtest view created...\e[0m"

cd ..

# Create ENV file
echo -e "\e[32mcreating .env file...\e[0m"
cat <<EOL >.env
PORT=9876
PUBLIC_DIRECTORY_CACHE_TIME = 31557600000
SESSION_MAX_AGE = 3600000
SESSION_SECRET = tempSecret!23
EOL
echo -e "\e[32m.env created...\e[0m"

# Create server file
echo -e "\e[32mcreating server file...\e[0m"
cat <<EOL >app.js
const express = require("express");
const dotenv = require("dotenv");
const bodyParser = require("body-parser");
const path = require("path");
const exphbs = require("express-handlebars");
const flash = require("express-flash");
const session = require("express-session");
const helpers = require("./helpers");

dotenv.config({
  path: "./.env",
});

const app = express();
const publicDirectory = path.join(__dirname, "./public");

// 1 year cache time for everything under public folder
const cacheTime = process.env.PUBLIC_DIRECTORY_CACHE_TIME;
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static(publicDirectory, { maxAge: cacheTime }));

// Set up Handlebars with helpers
const hbs = exphbs.create({
  helpers: helpers,
  defaultLayout: "main",
  layoutsDir: path.join(__dirname, "views/layouts"),
});

// UNCOMMENT WHEN NEEDED (for session stuff)
// =====================================================
// app.use(
//   session({
//     cookie: { maxAge: process.env.SESSION_MAX_AGE },
//     secret: process.env.SESSION_SECRET,
//     resave: false,
//     rolling: true,
//     saveUninitialized: false,
//   })
// );
// app.use(flash());

// app.use((req, res, next) => {
//   res.locals.message = req.session.message;
//   delete req.session.message;
//   next();
// });
// =======================================================

// Set Handlebars as the view engine
app.engine("handlebars", hbs.engine);
app.set("view engine", "handlebars");
app.set("views", path.join(__dirname, "views"));

// Define Routes directory
app.use("/", require("./routes/pages"));

app.listen(process.env.PORT, (err) =>
  !err
    ? console.log("Server started on Port " + process.env.PORT)
    : console.log("Something went wrong\n", err)
);
EOL
echo -e "\e[32mserver file created...\e[0m"
echo -e "\e[32mScript is complete!\e[0m"
echo -e "\e[33mYou can start your server with 'node app.js'\e[0"

# Run the server
# node app.js
