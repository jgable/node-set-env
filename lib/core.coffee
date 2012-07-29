EnvironmentSetter = require "./EnvironmentSetter"
ConfigReader = require "./ConfigReader"

module.exports = 
    run: (fileName, reader = new ConfigReader, setter = new EnvironmentSetter) ->
        console.log "core.run: #{fileName || "<none>"}"
        setFileData = (fileData) ->
            setter.setVariables fileData    

        reader.readFile setFileData, fileName
