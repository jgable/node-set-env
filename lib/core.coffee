fs = require "fs"
spawn = (require "child_process").spawn

ConfigReader = require "./ConfigReader"

module.exports = 
    run: (args) ->
        confFile = args[0]

        reader = new ConfigReader

        fileData = reader.readFile confFile

        for own key, val in fileData
            line = "#{key}=\"#{val}\""
            # May need to switch to exec here, haven't tested.
            spawn("export", [line]);


		