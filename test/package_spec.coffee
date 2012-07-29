should = require "should"
fs = require "fs"
path = require "path"

setEnv = require "../lib/index"
ConfigReader = require "../lib/ConfigReader"

# TODO: Move setting up to another file?
# TODO: Mock out the file system with injectr?

defaultConfig = 
    prop1: "1"
    prop2: "2"
    prop3: "3"
otherConfig = 
    propA: "A"
    propB: "B"
    propC: "C"

createTestFiles = (done) ->
    fs.writeFile "./env.json", JSON.stringify(defaultConfig, null, 4), (err) ->
        throw err if err

        fs.exists "./env.json", (exists) ->
            throw "File not created" if !exists

            # Create our other.json
            fs.writeFile "./other.json", JSON.stringify(otherConfig, null, 4), (otherErr) ->
                throw otherErr if otherErr

                fs.exists "./other.json", (otherExists) ->
                    throw "File not created (other)" if !otherExists
                    # Start our tests
                    do done

removeTestFiles = (done) ->
    # Delete test files.
    fs.unlink "./env.json", (err) ->
        throw err if err

        fs.unlink "./other.json", (er2) ->
            throw er2 if er2

            do done

describe "set-env", ->
    it "is an executable bin command"
	
    it "has a core module", ->
        should.exist setEnv.core

describe "ConfigReader", ->
    before (done) ->
        createTestFiles done
        

    it "treats file names as relative to the root directory of a node application.", -> true

    it "can read in a passed in configuration file name.", (done) ->
        reader = new ConfigReader

        thenTestResult = (result) ->
            should.exist result?.propA

            result?.propA.should.equal otherConfig.propA;

            do done

        reader.readFile thenTestResult, "./other.json"
        

    it "can read a file name without an extension.", (done) ->
        reader = new ConfigReader

        thenTestResult = (result) ->
            should.exist result?.propA

            result?.propA.should.equal otherConfig.propA;

            do done

        reader.readFile thenTestResult, "./other"

    it "falls back to env.json if no file name given.", (done) ->
        reader = new ConfigReader

        thenTestResult = (result) ->
            should.exist result?.prop1

            result?.prop1.should.equal defaultConfig.prop1

            do done

        reader.readFile thenTestResult

    after (done) ->
        removeTestFiles done

class FakeConfigReader
    constructor: (@returnData = { fake1: "1"}) ->

    readFile: (next, fileName) ->
        @fileNamePassed = fileName
        next @returnData


class FakeEnvironmentSetter
    setVariables: (data) ->
        @dataPassed = data


describe "core.run", ->
    before (done) ->
        createTestFiles done

    after (done) ->
        removeTestFiles done

    it "exists.", ->
        should.exist setEnv.core.run

    commonCoreRunTest = (readerTest) ->
        reader = new FakeConfigReader
        setter = new FakeEnvironmentSetter

        setEnv.core.run "fakefile", reader, setter

        readerTest reader, setter        

    it "loads the passed in file name", (done) ->
        commonCoreRunTest (reader) ->
            reader.fileNamePassed.should.equal "fakefile"
            do done

    it "sets variables", (done) ->
        commonCoreRunTest (reader, setter) ->
            should.exist setter.dataPassed
            setter.dataPassed.fake1.should.equal "1"
            do done




