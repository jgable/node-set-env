fs   = require "fs"
path = require "path"

class FileLoader
  constructor: (@fileName) ->
    @fullPath = path.join process.cwd(), @fileName

  getFileData: (next) ->

    fs.readFile @fullPath, (err, data) ->
        throw err if err

        next JSON.parse data


class ConfigReader
  constructor: (@loader = FileLoader, @extension = ".json") ->

  readFile: (next, fileName = "./env") ->

    fileName = fileName + @extension if fileName.slice(-5) != @extension.slice(-5)
    
    (new @loader fileName).getFileData next


module.exports = ConfigReader
