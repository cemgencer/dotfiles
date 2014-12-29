#!/usr/bin/env node
'use strict';

var
  EventEmitter, sys, exec,
  program, prompt, Rx,
  promptEmitter, promptSource,
  conf, confSource,
  tasks, taskSource,
  withPermission;

// invoke low-level utils
require('js-yaml');

EventEmitter = require('events').EventEmitter;
sys = require('sys');
exec = require('child_process').exec;

// invoke high-level utils
program = require('commander');
prompt = require('prompt');
Rx = require('rx');

// set up emitters and observers

conf = require('./conf.yml');
confSource = Rx.Observable.fromArray(conf.commands);

tasks = [];
taskSource = Rx.Observable.fromArray(tasks);

promptEmitter = (function () {
  var emitter = new EventEmitter();

  promptSource = Rx.Observable.fromEvent(emitter, 'prompt', function(args) {
    return args[0];
  });

  return function emit() {
    emitter.emit.apply(emitter, ['prompt'].concat(arguments));
  };
}());

// helpers

/**
 * wrapper for getting user input
 * @param  {Object} schema  Schema for prompt
 * @param  {String} command Unix command to execute if granted permission
 */
withPermission = function withPermission(schema, command) {
  if (program.interactive) {
    prompt.get(schema, function(err, result) {
      if (!err) {
        console.log('you chose'.bold, result[schema.name]);
        if (schema.accept.test(result[schema.name])) {
          exec(command, function(err, stdout, stderr) {
            promptEmitter(stdout);
          });
        } else {
          console.log('invalid response'.bold);
        }
      }
    });
  }
};

// configure program
program
  .version('0.0.1')
  // user will be prompted with each command, otherwise defaults will be used
  .option('-i, --interactive', 'Interactive mode')
  // TODO: this mode should log all output
  .option('-v, --verbose', 'Verbose mode')
  .parse(process.argv);

// configure prompt
prompt.message = 'dotfileconf';
prompt.start();

// subscribe to prompt observer
promptSource.subscribe(
  function(data) {
    console.log('what'.bold, data);
  },
  function(err) {
    console.error(err);
  },
  function() {
    console.log('completed'.bold);
  }
);

confSource.subscribe(
  function(data) {
    console.log(data);
    withPermission(data, 'echo '+ data.command +' executed with permission'.green);
    // tasks.push(data);
  },
  undefined,
  function() {
    console.log('conf parsing complete'.bold);
    // taskSource.subscribe(
    //   function(data) {
    //     console.log('task'.bold, data.command);
    //   },
    //   undefined,
    //   undefined
    // );
  }
);

// withPermission({
//   name: 'name',
//   description: 'testing (yN)',
//   pattern: /[yn]/i,
//   default: 'n',
//   accept: /y/i,
//   type: 'string'
// }, 'echo hi');
