EnvironmentSetter = require "./EnvironmentSetter"
ConfigReader = require "./ConfigReader"

module.exports = 
    run: (fileName, reader = new ConfigReader, setter = new EnvironmentSetter) ->
        setFileData = (fileData) ->
            setter.setVariables fileData    

        reader.readFile setFileData, fileName
