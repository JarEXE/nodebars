## Description

This script simplifies the process of initializing a new Node.js project for fellow Handlebars enjoyers. It includes about 10 Handlebars helper functions that I have used quite frequently.

## Details

The script will:

- Create standard directories typically used for a new Node server.
- Install some of the most common NPM packages.

### List of Packages Installed

- express
- nodemon
- dotenv
- body-parser
- path
- express-handlebars
- express-session
- express-flash
- axios

You will be prompted to choose whether to include Bootstrap and SweetAlert2 assets in your public assets directory. I went with Bootstrap as I never really had much success getting TailwindCSS working properly in a Node JS project ¯\_(ツ)\_/¯.

After the script completes, a new folder named `my-node-server_<date+time>` will be created in your project directory. You may want to rename it to something more meaningful.

## Instructions

1. Download the script into your desired project directory.
2. Make sure the script is executable:
   ```bash
   chmod +x new-handlebars-project.sh
   ```
3. Run the script:
   ```bash
   ./new-handlebars-project.sh
   ```
4. Start your Node server with:
   ```bash
   node app.js
   ```
   The server will run on port `9876`. This port can be configured in your `.env` file.

If the name sucks, then rename the script as you see fit.

### Using Nodemon

To utilize nodemon, edit the `package.json` scripts to include:

```json
"start": "nodemon app.js"
```

Then start your Node.js server with:

```bash
npm start
```

## Customization

Feel free to customize this script to better suit your needs, such as adding additional packages or improving file templates. Editing the script should be straightforward.

## Contributions and Suggestions

If you have any suggestions or contributions on how to improve this script, feel free to make suggestions or contribute.
