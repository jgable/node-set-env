should = require "should"
setEnv = require "../lib/index"
fs = require "fs"
path = require "path"

ConfigReader = require "../lib/ConfigReader"

# TODO: Move mocks to another file.

describe "set-env", ->
    it "is an executable bin command"
	
    it "has a core module", ->
        should.exist setEnv.core

describe "core", ->
    it "has a run method that takes in a configuration file name as a parameter.", ->
        should.exist setEnv.core.run
    
describe "ConfigReader", ->
    defaultConfig = 
        prop1: "1"
        prop2: "2"
        prop3: "3"
    otherConfig = 
        propA: "A"
        propB: "B"
        propC: "C"

    before (done) ->

        # Create our testing env.json in the root
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
        # Delete test files.
        fs.unlink "./env.json", (err) ->
            throw err if err

            fs.unlink "./other.json", (er2) ->
                throw er2 if er2

                do done

