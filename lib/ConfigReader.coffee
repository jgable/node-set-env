fs   = require "fs"
path = require "path"

class FileLoader
  constructor: (@fileName) ->
    @fullPath = path.join process.cwd(), @fileName

  getFileData: (next) ->

    fs.readFile @fullPath, (err, data) =>
        throw new Error("Failed to open file: #{@fullPath}") if err

        next JSON.parse data


class ConfigReader
  constructor: (@loader = FileLoader, @extension = ".json") ->

  readFile: (next, fileName = "./env") ->
    # This will fail hard for any extensions less than 5 characters.
    fileName = fileName + @extension if fileName.slice(-5) != @extension.slice(-5)
    
    (new @loader fileName).getFileData next


module.exports = ConfigReader
