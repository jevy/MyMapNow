/**
 * Top level namespace for Jasmine, a lightweight JavaScript BDD/spec/testing framework.
 * 
 * @namespace
 */
var jasmine = {};

/**
 * @private
 */
jasmine.unimplementedMethod_ = function() {
  throw new Error("unimplemented method");
};

/**
 * Allows for bound functions to be comapred.  Internal use only.
 *
 * @ignore
 * @private
 * @param base {Object} bound 'this' for the function
 * @param name {Function} function to find
 */
jasmine.bindOriginal_ = function(base, name) {
  var original = base[name];
  return function() {
    return original.apply(base, arguments);
  };
};

jasmine.setTimeout = jasmine.bindOriginal_(window, 'setTimeout');
jasmine.clearTimeout = jasmine.bindOriginal_(window, 'clearTimeout');
jasmine.setInterval = jasmine.bindOriginal_(window, 'setInterval');
jasmine.clearInterval = jasmine.bindOriginal_(window, 'clearInterval');

jasmine.MessageResult = function(text) {
  this.type = 'MessageResult';
  this.text = text;
  this.trace = new Error(); // todo: test better
};

jasmine.ExpectationResult = function(passed, message, details) {
  this.type = 'ExpectationResult';
  this.passed = passed;
  this.message = message;
  this.details = details;
  this.trace = new Error(message); // todo: test better
};

/**
 * Getter for the Jasmine environment. Ensures one gets created
 */
jasmine.getEnv = function() {
  return jasmine.currentEnv_ = jasmine.currentEnv_ || new jasmine.Env();
};

/**
 * @ignore
 * @private
 * @param value
 * @returns {Boolean}
 */
jasmine.isArray_ = function(value) {
  return value &&
  typeof value === 'object' &&
  typeof value.length === 'number' &&
  typeof value.splice === 'function' &&
  !(value.propertyIsEnumerable('length'));
};

/**
 * Pretty printer for expecations.  Takes any object and turns it into a human-readable string.
 *
 * @param value {Object} an object to be outputted
 * @returns {String}
 */
jasmine.pp = function(value) {
  var stringPrettyPrinter = new jasmine.StringPrettyPrinter();
  stringPrettyPrinter.format(value);
  return stringPrettyPrinter.string;
};

/**
 * Returns true if the object is a DOM Node.
 *
 * @param {Object} obj object to check
 * @returns {Boolean}
 */
jasmine.isDomNode = function(obj) {
  return obj['nodeType'] > 0;
};

/**
 * Returns a matchable 'generic' object of the class type.  For use in expecations of type when values don't matter.
 *
 * @example
 * // don't care about which function is passed in, as long as it's a function
 * expect(mySpy).wasCalledWith(jasmine.any(Function));
 *
 * @param {Class} clazz
 * @returns matchable object of the type clazz
 */
jasmine.any = function(clazz) {
  return new jasmine.Matchers.Any(clazz);
};

/**
 * Jasmine Spies are test doubles that can act as stubs, spies, fakes or when used in an expecation, mocks.
 *
 * Spies should be created in test setup, before expectations.  They can then be checked, using the standard Jasmine
 * expectation syntax. Spies can be checked if they were called or not and what the calling params were.
 *
 * A Spy has the following mehtod: wasCalled, callCount, mostRecentCall, and argsForCall (see docs)
 * Spies are torn down at the end of every spec.
 *
 * Note: Do <b>not</b> call new jasmine.Spy() directly - a spy must be created using spyOn, jasmine.createSpy or jasmine.createSpyObj.
 * 
 * @example
 * // a stub
 * var myStub = jasmine.createSpy('myStub');  // can be used anywhere
 *
 * // spy example
 * var foo = {
 *   not: function(bool) { return !bool; }
 * }
 *
 * // actual foo.not will not be called, execution stops
 * spyOn(foo, 'not');

 // foo.not spied upon, execution will continue to implementation
 * spyOn(foo, 'not').andCallThrough();
 *
 * // fake example
 * var foo = {
 *   not: function(bool) { return !bool; }
 * }
 *
 * // foo.not(val) will return val
 * spyOn(foo, 'not').andCallFake(function(value) {return value;});
 *
 * // mock example
 * foo.not(7 == 7);
 * expect(foo.not).wasCalled();
 * expect(foo.not).wasCalledWith(true);
 *
 * @constructor
 * @see spyOn, jasmine.createSpy, jasmine.createSpyObj
 * @param {String} name
 */
jasmine.Spy = function(name) {
  /**
   * The name of the spy, if provided.
   */
  this.identity = name || 'unknown';
  /**
   *  Is this Object a spy?
   */
  this.isSpy = true;
  /**
   * The acutal function this spy stubs.
   */
  this.plan = function() {};
  /**
   * Tracking of the most recent call to the spy.
   * @example
   * var mySpy = jasmine.createSpy('foo');
   * mySpy(1, 2);
   * mySpy.mostRecentCall.args = [1, 2];
   */
  this.mostRecentCall = {};

  /**
   * Holds arguments for each call to the spy, indexed by call count
   * @example
   * var mySpy = jasmine.createSpy('foo');
   * mySpy(1, 2);
   * mySpy(7, 8);
   * mySpy.mostRecentCall.args = [7, 8];
   * mySpy.argsForCall[0] = [1, 2];
   * mySpy.argsForCall[1] = [7, 8];
   */
  this.argsForCall = [];
};

/**
 * Tells a spy to call through to the actual implemenatation.
 *
 * @example
 * var foo = {
 *   bar: function() { // do some stuff }
 * }
 * 
 * // defining a spy on an existing property: foo.bar
 * spyOn(foo, 'bar').andCallThrough();
 */
jasmine.Spy.prototype.andCallThrough = function() {
  this.plan = this.originalValue;
  return this;
};

/**
 * For setting the return value of a spy.
 *
 * @example
 * // defining a spy from scratch: foo() returns 'baz'
 * var foo = jasmine.createSpy('spy on foo').andReturn('baz');
 *
 * // defining a spy on an existing property: foo.bar() returns 'baz'
 * spyOn(foo, 'bar').andReturn('baz');
 *
 * @param {Object} value
 */
jasmine.Spy.prototype.andReturn = function(value) {
  this.plan = function() {
    return value;
  };
  return this;
};

/**
 * For throwing an exception when a spy is called.
 *
 * @example
 * // defining a spy from scratch: foo() throws an exception w/ message 'ouch'
 * var foo = jasmine.createSpy('spy on foo').andThrow('baz');
 *
 * // defining a spy on an existing property: foo.bar() throws an exception w/ message 'ouch'
 * spyOn(foo, 'bar').andThrow('baz');
 *
 * @param {String} exceptionMsg
 */
jasmine.Spy.prototype.andThrow = function(exceptionMsg) {
  this.plan = function() {
    throw exceptionMsg;
  };
  return this;
};

/**
 * Calls an alternate implementation when a spy is called.
 *
 * @example
 * var baz = function() {
 *   // do some stuff, return something
 * }
 * // defining a spy from scratch: foo() calls the function baz
 * var foo = jasmine.createSpy('spy on foo').andCall(baz);
 *
 * // defining a spy on an existing property: foo.bar() calls an anonymnous function
 * spyOn(foo, 'bar').andCall(function() { return 'baz';} );
 *
 * @param {Function} fakeFunc
 */
jasmine.Spy.prototype.andCallFake = function(fakeFunc) {
  this.plan = fakeFunc;
  return this;
};

/**
 * Resets all of a spy's the tracking variables so that it can be used again.
 *
 * @example
 * spyOn(foo, 'bar');
 *
 * foo.bar();
 *
 * expect(foo.bar.callCount).toEqual(1);
 *
 * foo.bar.reset();
 *
 * expect(foo.bar.callCount).toEqual(0);
 */
jasmine.Spy.prototype.reset = function() {
  this.wasCalled = false;
  this.callCount = 0;
  this.argsForCall = [];
  this.mostRecentCall = {};
};

jasmine.createSpy = function(name) {

  var spyObj = function() {
    spyObj.wasCalled = true;
    spyObj.callCount++;
    var args = jasmine.util.argsToArray(arguments);
    //spyObj.mostRecentCall = {
    //  object: this,
    //  args: args
    //};
    spyObj.mostRecentCall.object = this;
    spyObj.mostRecentCall.args = args;
    spyObj.argsForCall.push(args);
    return spyObj.plan.apply(this, arguments);
  };

  var spy = new jasmine.Spy(name);
  
  for(var prop in spy) {
    spyObj[prop] = spy[prop];
  }
  
  spyObj.reset();

  return spyObj;
};

/**
 * Creates a more complicated spy: an Object that has every property a function that is a spy.  Used for stubbing something
 * large in one call.
 *
 * @param {String} baseName name of spy class
 * @param {Array} methodNames array of names of methods to make spies
 */
jasmine.createSpyObj = function(baseName, methodNames) {
  var obj = {};
  for (var i = 0; i < methodNames.length; i++) {
    obj[methodNames[i]] = jasmine.createSpy(baseName + '.' + methodNames[i]);
  }
  return obj;
};

jasmine.log = function(message) {
  jasmine.getEnv().currentSpec.getResults().log(message);
};

/**
 * Function that installs a spy on an existing object's method name.  Used within a Spec to create a spy.
 *
 * @example
 * // spy example
 * var foo = {
 *   not: function(bool) { return !bool; }
 * }
 * spyOn(foo, 'not'); // actual foo.not will not be called, execution stops
 *
 * @see jasmine.createSpy
 * @param obj
 * @param methodName
 * @returns a Jasmine spy that can be chained with all spy methods
 */
var spyOn = function(obj, methodName) {
  return jasmine.getEnv().currentSpec.spyOn(obj, methodName);
};

/**
 * Creates a Jasmine spec that will be added to the current suite.
 *
 * // TODO: pending tests
 *
 * @example
 * it('should be true', function() {
 *   expect(true).toEqual(true);
 * });
 *
 * @param {String} desc description of this specification
 * @param {Function} func defines the preconditions and expectations of the spec
 */
var it = function(desc, func) {
  return jasmine.getEnv().it(desc, func);
};

/**
 * Creates a <em>disabled</em> Jasmine spec.
 *
 * A convenience method that allows existing specs to be disabled temporarily during development.
 *
 * @param {String} desc description of this specification
 * @param {Function} func defines the preconditions and expectations of the spec
 */
var xit = function(desc, func) {
  return jasmine.getEnv().xit(desc, func);
};

/**
 * Starts a chain for a Jasmine expectation.
 *
 * It is passed an Object that is the actual value and should chain to one of the many
 * jasmine.Matchers functions.
 *
 * @param {Object} actual Actual value to test against and expected value
 */
var expect = function(actual) {
  return jasmine.getEnv().currentSpec.expect(actual);
};

/**
 * Defines part of a jasmine spec.  Used in cominbination with waits or waitsFor in asynchrnous specs.
 *
 * @param {Function} func Function that defines part of a jasmine spec.
 */
var runs = function(func) {
  jasmine.getEnv().currentSpec.runs(func);
};

/**
 * Waits for a timeout before moving to the next runs()-defined block.
 * @param {Number} timeout
 */
var waits = function(timeout) {
  jasmine.getEnv().currentSpec.waits(timeout);
};

/**
 * Waits for the latchFunction to return true before proceeding to the next runs()-defined block.
 *  
 * @param {Number} timeout
 * @param {Function} latchFunction
 * @param {String} message
 */
var waitsFor = function(timeout, latchFunction, message) {
  jasmine.getEnv().currentSpec.waitsFor(timeout, latchFunction, message);
};

/**
 * A function that is called before each spec in a suite.
 *
 * Used for spec setup, including validating assumptions.
 *
 * @param {Function} beforeEachFunction
 */
var beforeEach = function(beforeEachFunction) {
  jasmine.getEnv().beforeEach(beforeEachFunction);
};

/**
 * A function that is called after each spec in a suite.
 *
 * Used for restoring any state that is hijacked during spec execution.
 *
 * @param {Function} afterEachFunction
 */
var afterEach = function(afterEachFunction) {
  jasmine.getEnv().afterEach(afterEachFunction);
};

/**
 * Defines a suite of specifications.
 *
 * Stores the description and all defined specs in the Jasmine environment as one suite of specs. Variables declared
 * are accessible by calls to beforeEach, it, and afterEach. Describe blocks can be nested, allowing for specialization
 * of setup in some tests.
 *
 * @example
 * // TODO: a simple suite
 *
 * // TODO: a simple suite with a nested describe block
 *
 * @param {String} description A string, usually the class under test.
 * @param {Function} specDefinitions function that defines several specs.
 */
var describe = function(description, specDefinitions) {
  return jasmine.getEnv().describe(description, specDefinitions);
};

/**
 * Disables a suite of specifications.  Used to disable some suites in a file, or files, temporarily during development.
 *
 * @param {String} description A string, usually the class under test.
 * @param {Function} specDefinitions function that defines several specs.
 */
var xdescribe = function(description, specDefinitions) {
  return jasmine.getEnv().xdescribe(description, specDefinitions);
};


jasmine.XmlHttpRequest = XMLHttpRequest;

// Provide the XMLHttpRequest class for IE 5.x-6.x:
if (typeof XMLHttpRequest == "undefined") jasmine.XmlHttpRequest = function() {
  try {
    return new ActiveXObject("Msxml2.XMLHTTP.6.0");
  } catch(e) {
  }
  try {
    return new ActiveXObject("Msxml2.XMLHTTP.3.0");
  } catch(e) {
  }
  try {
    return new ActiveXObject("Msxml2.XMLHTTP");
  } catch(e) {
  }
  try {
    return new ActiveXObject("Microsoft.XMLHTTP");
  } catch(e) {
  }
  throw new Error("This browser does not support XMLHttpRequest.");
};

/**
 * Adds suite files to an HTML document so that they are executed, thus adding them to the current
 * Jasmine environment.
 *
 * @param {String} url path to the file to include
 * @param {Boolean} opt_global
 */
jasmine.include = function(url, opt_global) {
  if (opt_global) {
    document.write('<script type="text/javascript" src="' + url + '"></' + 'script>');
  } else {
    var xhr;
    try {
      xhr = new jasmine.XmlHttpRequest();
      xhr.open("GET", url, false);
      xhr.send(null);
    } catch(e) {
      throw new Error("couldn't fetch " + url + ": " + e);
    }

    return eval(xhr.responseText);
  }
};
/**
 * @namespace
 */
jasmine.util = {};

/**
 * Declare that a child class inherite it's prototype from the parent class.
 *
 * @private
 * @param {Function} childClass
 * @param {Function} parentClass
 */
jasmine.util.inherit = function(childClass, parentClass) {
  var subclass = function() {
  };
  subclass.prototype = parentClass.prototype;
  childClass.prototype = new subclass;
};

jasmine.util.formatException = function(e) {
  var lineNumber;
  if (e.line) {
    lineNumber = e.line;
  }
  else if (e.lineNumber) {
    lineNumber = e.lineNumber;
  }

  var file;

  if (e.sourceURL) {
    file = e.sourceURL;
  }
  else if (e.fileName) {
    file = e.fileName;
  }

  var message = (e.name && e.message) ? (e.name + ': ' + e.message) : e.toString();

  if (file && lineNumber) {
    message += ' in ' + file + ' (line ' + lineNumber + ')';
  }

  return message;
};

jasmine.util.htmlEscape = function(str) {
  if (!str) return str;
  return str.replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;');
};

jasmine.util.argsToArray = function(args) {
  var arrayOfArgs = [];
  for (var i = 0; i < args.length; i++) arrayOfArgs.push(args[i]);
  return arrayOfArgs;
};

/**
 * Environment for Jasmine
 *
 * @constructor
 */
jasmine.Env = function() {
  this.currentSpec = null;
  this.currentSuite = null;
  this.currentRunner = new jasmine.Runner(this);
  this.currentlyRunningTests = false;

  this.reporter = new jasmine.MultiReporter();

  this.updateInterval = 0;
  this.lastUpdate = 0;
  this.specFilter = function() {
    return true;
  };

  this.nextSpecId_ = 0;
  this.nextSuiteId_ = 0;
  this.equalityTesters_ = [];
};


jasmine.Env.prototype.setTimeout = jasmine.setTimeout;
jasmine.Env.prototype.clearTimeout = jasmine.clearTimeout;
jasmine.Env.prototype.setInterval = jasmine.setInterval;
jasmine.Env.prototype.clearInterval = jasmine.clearInterval;

/**
 * Register a reporter to receive status updates from Jasmine.
 * @param {jasmine.Reporter} reporter An object which will receive status updates.
 */
jasmine.Env.prototype.addReporter = function(reporter) {
  this.reporter.addReporter(reporter);
};

jasmine.Env.prototype.execute = function() {
  this.currentRunner.execute();
};

jasmine.Env.prototype.describe = function(description, specDefinitions) {
  var suite = new jasmine.Suite(this, description, specDefinitions, this.currentSuite);

  var parentSuite = this.currentSuite;
  if (parentSuite) {
    parentSuite.specs.push(suite);
  } else {
    this.currentRunner.suites.push(suite);
  }

  this.currentSuite = suite;

  specDefinitions.call(suite);

  this.currentSuite = parentSuite;

  return suite;
};

jasmine.Env.prototype.beforeEach = function(beforeEachFunction) {
  this.currentSuite.beforeEach(beforeEachFunction);
};

jasmine.Env.prototype.afterEach = function(afterEachFunction) {
  this.currentSuite.afterEach(afterEachFunction);
};

jasmine.Env.prototype.xdescribe = function(desc, specDefinitions) {
  return {
    execute: function() {
    }
  };
};

jasmine.Env.prototype.it = function(description, func) {
  var spec = new jasmine.Spec(this, this.currentSuite, description);
  this.currentSuite.specs.push(spec);
  this.currentSpec = spec;

  if (func) {
    spec.addToQueue(func);
  }

  return spec;
};

jasmine.Env.prototype.xit = function(desc, func) {
  return {
    id: this.nextSpecId_++,
    runs: function() {
    }
  };
};

jasmine.Env.prototype.compareObjects_ = function(a, b, mismatchKeys, mismatchValues) {
  if (a.__Jasmine_been_here_before__ === b && b.__Jasmine_been_here_before__ === a) {
    return true;
  }

  a.__Jasmine_been_here_before__ = b;
  b.__Jasmine_been_here_before__ = a;

  var hasKey = function(obj, keyName) {
    return obj != null && obj[keyName] !== undefined;
  };

  for (var property in b) {
    if (!hasKey(a, property) && hasKey(b, property)) {
      mismatchKeys.push("expected has key '" + property + "', but missing from <b>actual</b>.");
    }
  }
  for (property in a) {
    if (!hasKey(b, property) && hasKey(a, property)) {
      mismatchKeys.push("<b>expected</b> missing key '" + property + "', but present in actual.");
    }
  }
  for (property in b) {
    if (property == '__Jasmine_been_here_before__') continue;
    if (!this.equals_(a[property], b[property], mismatchKeys, mismatchValues)) {
      mismatchValues.push("'" + property + "' was<br /><br />'" + (b[property] ? jasmine.util.htmlEscape(b[property].toString()) : b[property]) + "'<br /><br />in expected, but was<br /><br />'" + (a[property] ? jasmine.util.htmlEscape(a[property].toString()) : a[property]) + "'<br /><br />in actual.<br />");
    }
  }

  if (jasmine.isArray_(a) && jasmine.isArray_(b) && a.length != b.length) {
    mismatchValues.push("arrays were not the same length");
  }

  delete a.__Jasmine_been_here_before__;
  delete b.__Jasmine_been_here_before__;
  return (mismatchKeys.length == 0 && mismatchValues.length == 0);
};

jasmine.Env.prototype.equals_ = function(a, b, mismatchKeys, mismatchValues) {
  mismatchKeys = mismatchKeys || [];
  mismatchValues = mismatchValues || [];

  if (a === b) return true;

  if (a === undefined || a === null || b === undefined || b === null) {
    return (a == undefined && b == undefined);
  }

  if (jasmine.isDomNode(a) && jasmine.isDomNode(b)) {
    return a === b;
  }

  if (a instanceof Date && b instanceof Date) {
    return a.getTime() == b.getTime();
  }

  if (a instanceof jasmine.Matchers.Any) {
    return a.matches(b);
  }

  if (b instanceof jasmine.Matchers.Any) {
    return b.matches(a);
  }

  if (typeof a === "object" && typeof b === "object") {
    return this.compareObjects_(a, b, mismatchKeys, mismatchValues);
  }

  for (var i = 0; i < this.equalityTesters_.length; i++) {
    var equalityTester = this.equalityTesters_[i];
    var result = equalityTester(a, b, this, mismatchKeys, mismatchValues);
    if (result !== undefined) return result;
  }

  //Straight check
  return (a === b);
};

jasmine.Env.prototype.contains_ = function(haystack, needle) {
  if (jasmine.isArray_(haystack)) {
    for (var i = 0; i < haystack.length; i++) {
      if (this.equals_(haystack[i], needle)) return true;
    }
    return false;
  }
  return haystack.indexOf(needle) >= 0;
};

jasmine.Env.prototype.addEqualityTester = function(equalityTester) {
  this.equalityTesters_.push(equalityTester);
};
/**
 * base for Runner & Suite: allows for a queue of functions to get executed, allowing for
 *   any one action to complete, including asynchronous calls, before going to the next
 *   action.
 *
 * @constructor
 * @param {jasmine.Env} env
 */
jasmine.ActionCollection = function(env) {
  this.env = env;
  this.actions = [];
  this.index = 0;
  this.finished = false;
};

/**
 * Marks the collection as done & calls the finish callback, if there is one
 */
jasmine.ActionCollection.prototype.finish = function() {
  if (this.finishCallback) {
    this.finishCallback();
  }
  this.finished = true;
};

/**
 * Starts executing the queue of functions/actions.
 */
jasmine.ActionCollection.prototype.execute = function() {
  if (this.actions.length > 0) {
    this.next();
  }
};

/**
 * Gets the current action.
 */
jasmine.ActionCollection.prototype.getCurrentAction = function() {
  return this.actions[this.index];
};

/**
 * Executes the next queued function/action. If there are no more in the queue, calls #finish.
 */
jasmine.ActionCollection.prototype.next = function() {
  if (this.index >= this.actions.length) {
    this.finish();
    return;
  }

  var currentAction = this.getCurrentAction();

  currentAction.execute(this);

  if (currentAction.afterCallbacks) {
    for (var i = 0; i < currentAction.afterCallbacks.length; i++) {
      try {
        currentAction.afterCallbacks[i]();
      } catch (e) {
        alert(e);
      }
    }
  }

  this.waitForDone(currentAction);
};

jasmine.ActionCollection.prototype.waitForDone = function(action) {
  var self = this;
  var afterExecute = function afterExecute() {
    self.index++;
    self.next();
  };

  if (action.finished) {
    var now = new Date().getTime();
    if (this.env.updateInterval && now - this.env.lastUpdate > this.env.updateInterval) {
      this.env.lastUpdate = now;
      this.env.setTimeout(afterExecute, 0);
    } else {
      afterExecute();
    }
    return;
  }

  var id = this.env.setInterval(function() {
    if (action.finished) {
      self.env.clearInterval(id);
      afterExecute();
    }
  }, 150);
};
/** No-op base class for Jasmine reporters.
 *
 * @constructor
 */
jasmine.Reporter = function() {
};

//noinspection JSUnusedLocalSymbols
jasmine.Reporter.prototype.reportRunnerStarting = function(runner) {
};

//noinspection JSUnusedLocalSymbols
jasmine.Reporter.prototype.reportRunnerResults = function(runner) {
};

//noinspection JSUnusedLocalSymbols
jasmine.Reporter.prototype.reportSuiteResults = function(suite) {
};

//noinspection JSUnusedLocalSymbols
jasmine.Reporter.prototype.reportSpecResults = function(spec) {
};

//noinspection JSUnusedLocalSymbols
jasmine.Reporter.prototype.log = function(str) {
};

/** JavaScript API reporter.
 *
 * @constructor
 */
jasmine.JsApiReporter = function() {
  this.started = false;
  this.finished = false;
  this.suites = [];
  this.results = {};
};

jasmine.JsApiReporter.prototype.reportRunnerStarting = function(runner) {
  this.started = true;

  for (var i = 0; i < runner.suites.length; i++) {
    var suite = runner.suites[i];
    this.suites.push(this.summarize_(suite));
  }
};

jasmine.JsApiReporter.prototype.summarize_ = function(suiteOrSpec) {
  var summary = {
    id: suiteOrSpec.id,
    name: suiteOrSpec.description,
    type: suiteOrSpec instanceof jasmine.Suite ? 'suite' : 'spec',
    children: []
  };

  if (suiteOrSpec.specs) {
    for (var i = 0; i < suiteOrSpec.specs.length; i++) {
      summary.children.push(this.summarize_(suiteOrSpec.specs[i]));
    }
  }

  return summary;
};

//noinspection JSUnusedLocalSymbols
jasmine.JsApiReporter.prototype.reportRunnerResults = function(runner) {
  this.finished = true;
};

//noinspection JSUnusedLocalSymbols
jasmine.JsApiReporter.prototype.reportSuiteResults = function(suite) {
};

//noinspection JSUnusedLocalSymbols
jasmine.JsApiReporter.prototype.reportSpecResults = function(spec) {
  this.results[spec.id] = {
    messages: spec.results.getItems(),
    result: spec.results.failedCount > 0 ? "failed" : "passed"
  };
};

//noinspection JSUnusedLocalSymbols
jasmine.JsApiReporter.prototype.log = function(str) {
};

jasmine.Matchers = function(env, actual, results) {
  this.env = env;
  this.actual = actual;
  this.passing_message = 'Passed.';
  this.results = results || new jasmine.NestedResults();
};

jasmine.Matchers.pp = function(str) {
  return jasmine.util.htmlEscape(jasmine.pp(str));
};

jasmine.Matchers.prototype.getResults = function() {
  return this.results;
};

jasmine.Matchers.prototype.report = function(result, failing_message, details) {
  this.results.addResult(new jasmine.ExpectationResult(result, result ? this.passing_message : failing_message, details));
  return result;
};

/**
 * Matcher that compares the actual to the expected using ===.
 *
 * @param expected
 */
jasmine.Matchers.prototype.toBe = function(expected) {
  return this.report(this.actual === expected, 'Expected<br /><br />' + jasmine.Matchers.pp(expected)
    + '<br /><br />to be the same object as<br /><br />' + jasmine.Matchers.pp(this.actual)
    + '<br />');
};

/**
 * Matcher that compares the actual to the expected using !==
 * @param expected
 */
jasmine.Matchers.prototype.toNotBe = function(expected) {
  return this.report(this.actual !== expected, 'Expected<br /><br />' + jasmine.Matchers.pp(expected)
    + '<br /><br />to be a different object from actual, but they were the same.');
};

/**
 * Matcher that compares the actual to the expected using common sense equality. Handles Objects, Arrays, etc.
 *
 * @param expected
 */
jasmine.Matchers.prototype.toEqual = function(expected) {
  var mismatchKeys = [];
  var mismatchValues = [];

  var formatMismatches = function(name, array) {
    if (array.length == 0) return '';
    var errorOutput = '<br /><br />Different ' + name + ':<br />';
    for (var i = 0; i < array.length; i++) {
      errorOutput += array[i] + '<br />';
    }
    return errorOutput;
  };

  return this.report(this.env.equals_(this.actual, expected, mismatchKeys, mismatchValues),
    'Expected<br /><br />' + jasmine.Matchers.pp(expected)
      + '<br /><br />but got<br /><br />' + jasmine.Matchers.pp(this.actual)
      + '<br />'
      + formatMismatches('Keys', mismatchKeys)
      + formatMismatches('Values', mismatchValues), {
    matcherName: 'toEqual', expected: expected, actual: this.actual
  });
};
/** @deprecated */
jasmine.Matchers.prototype.should_equal = jasmine.Matchers.prototype.toEqual;

/**
 * Matcher that compares the actual to the expected using the ! of jasmine.Matchers.toEqual
 * @param expected
 */
jasmine.Matchers.prototype.toNotEqual = function(expected) {
  return this.report(!this.env.equals_(this.actual, expected),
    'Expected ' + jasmine.Matchers.pp(expected) + ' to not equal ' + jasmine.Matchers.pp(this.actual) + ', but it does.');
};
/** @deprecated */
jasmine.Matchers.prototype.should_not_equal = jasmine.Matchers.prototype.toNotEqual;

/**
 * Matcher that compares the actual to the expected using a regular expression.  Constructs a RegExp, so takes
 * a pattern or a String.
 *
 * @param reg_exp
 */
jasmine.Matchers.prototype.toMatch = function(reg_exp) {
  return this.report((new RegExp(reg_exp).test(this.actual)),
    'Expected ' + jasmine.Matchers.pp(this.actual) + ' to match ' + reg_exp + '.');
};
/** @deprecated */
jasmine.Matchers.prototype.should_match = jasmine.Matchers.prototype.toMatch;

/**
 * Matcher that compares the actual to the expected using the boolean inverse of jasmine.Matchers.toMatch
 * @param reg_exp
 */
jasmine.Matchers.prototype.toNotMatch = function(reg_exp) {
  return this.report((!new RegExp(reg_exp).test(this.actual)),
    'Expected ' + jasmine.Matchers.pp(this.actual) + ' to not match ' + reg_exp + '.');
};
/** @deprecated */
jasmine.Matchers.prototype.should_not_match = jasmine.Matchers.prototype.toNotMatch;

/**
 * Matcher that compares the acutal to undefined.
 */
jasmine.Matchers.prototype.toBeDefined = function() {
  return this.report((this.actual !== undefined),
    'Expected a value to be defined but it was undefined.');
};
/** @deprecated */
jasmine.Matchers.prototype.should_be_defined = jasmine.Matchers.prototype.toBeDefined;

/**
 * Matcher that compares the actual to null.
 *
 */
jasmine.Matchers.prototype.toBeNull = function() {
  return this.report((this.actual === null),
    'Expected a value to be null but it was ' + jasmine.Matchers.pp(this.actual) + '.');
};
/** @deprecated */
jasmine.Matchers.prototype.should_be_null = jasmine.Matchers.prototype.toBeNull;

/**
 * Matcher that boolean not-nots the actual.
 */
jasmine.Matchers.prototype.toBeTruthy = function() {
  return this.report(!!this.actual,
    'Expected a value to be truthy but it was ' + jasmine.Matchers.pp(this.actual) + '.');
};
/** @deprecated */
jasmine.Matchers.prototype.should_be_truthy = jasmine.Matchers.prototype.toBeTruthy;

/**
 * Matcher that boolean nots the actual.
 */
jasmine.Matchers.prototype.toBeFalsy = function() {
  return this.report(!this.actual,
    'Expected a value to be falsy but it was ' + jasmine.Matchers.pp(this.actual) + '.');
};
/** @deprecated */
jasmine.Matchers.prototype.should_be_falsy = jasmine.Matchers.prototype.toBeFalsy;

/**
 * Matcher that checks to see if the acutal, a Jasmine spy, was called.
 */
jasmine.Matchers.prototype.wasCalled = function() {
  if (!this.actual || !this.actual.isSpy) {
    return this.report(false, 'Expected a spy, but got ' + jasmine.Matchers.pp(this.actual) + '.');
  }
  if (arguments.length > 0) {
    return this.report(false, 'wasCalled matcher does not take arguments');
  }
  return this.report((this.actual.wasCalled),
    'Expected spy "' + this.actual.identity + '" to have been called, but it was not.');
};
/** @deprecated */
jasmine.Matchers.prototype.was_called = jasmine.Matchers.prototype.wasCalled;

/**
 * Matcher that checks to see if the acutal, a Jasmine spy, was not called.
 */
jasmine.Matchers.prototype.wasNotCalled = function() {
  if (!this.actual || !this.actual.isSpy) {
    return this.report(false, 'Expected a spy, but got ' + jasmine.Matchers.pp(this.actual) + '.');
  }
  return this.report((!this.actual.wasCalled),
    'Expected spy "' + this.actual.identity + '" to not have been called, but it was.');
};
/** @deprecated */
jasmine.Matchers.prototype.was_not_called = jasmine.Matchers.prototype.wasNotCalled;

/**
 * Matcher that checks to see if the acutal, a Jasmine spy, was called with a set of parameters.
 *
 * @example
 *
 */
jasmine.Matchers.prototype.wasCalledWith = function() {
  if (!this.actual || !this.actual.isSpy) {
    return this.report(false, 'Expected a spy, but got ' + jasmine.Matchers.pp(this.actual) + '.', {
      matcherName: 'wasCalledWith'
    });
  }

  var args = jasmine.util.argsToArray(arguments);

  return this.report(this.env.contains_(this.actual.argsForCall, args),
    'Expected ' + jasmine.Matchers.pp(this.actual.argsForCall) + ' to contain ' + jasmine.Matchers.pp(args) + ', but it does not.', {
    matcherName: 'wasCalledWith', expected: args, actual: this.actual.argsForCall
  });
};

/**
 * Matcher that checks that the expected item is an element in the actual Array.
 *
 * @param {Object} item
 */
jasmine.Matchers.prototype.toContain = function(item) {
  return this.report(this.env.contains_(this.actual, item),
    'Expected ' + jasmine.Matchers.pp(this.actual) + ' to contain ' + jasmine.Matchers.pp(item) + ', but it does not.', {
    matcherName: 'toContain', expected: item, actual: this.actual
  });
};

/**
 * Matcher that checks that the expected item is NOT an element in the actual Array.
 *
 * @param {Object} item
 */
jasmine.Matchers.prototype.toNotContain = function(item) {
  return this.report(!this.env.contains_(this.actual, item),
    'Expected ' + jasmine.Matchers.pp(this.actual) + ' not to contain ' + jasmine.Matchers.pp(item) + ', but it does.');
};

/**
 * Matcher that checks that the expected exception was thrown by the actual.
 *
 * @param {String} expectedException
 */
jasmine.Matchers.prototype.toThrow = function(expectedException) {
  var exception = null;
  try {
    this.actual();
  } catch (e) {
    exception = e;
  }
  if (expectedException !== undefined) {
    if (exception == null) {
      return this.report(false, "Expected function to throw " + jasmine.Matchers.pp(expectedException) + ", but it did not.");
    }
    return this.report(
      this.env.equals_(
        exception.message || exception,
        expectedException.message || expectedException),
      "Expected function to throw " + jasmine.Matchers.pp(expectedException) + ", but it threw " + jasmine.Matchers.pp(exception) + ".");
  } else {
    return this.report(exception != null, "Expected function to throw an exception, but it did not.");
  }
};

jasmine.Matchers.Any = function(expectedClass) {
  this.expectedClass = expectedClass;
};

jasmine.Matchers.Any.prototype.matches = function(other) {
  if (this.expectedClass == String) {
    return typeof other == 'string' || other instanceof String;
  }

  if (this.expectedClass == Number) {
    return typeof other == 'number' || other instanceof Number;
  }

  if (this.expectedClass == Function) {
    return typeof other == 'function' || other instanceof Function;
  }

  if (this.expectedClass == Object) {
    return typeof other == 'object';
  }

  return other instanceof this.expectedClass;
};

jasmine.Matchers.Any.prototype.toString = function() {
  return '<jasmine.any(' + this.expectedClass + ')>';
};

// Mock setTimeout, clearTimeout
// Contributed by Pivotal Computer Systems, www.pivotalsf.com

jasmine.FakeTimer = function() {
  this.reset();

  var self = this;
  self.setTimeout = function(funcToCall, millis) {
    self.timeoutsMade++;
    self.scheduleFunction(self.timeoutsMade, funcToCall, millis, false);
    return self.timeoutsMade;
  };

  self.setInterval = function(funcToCall, millis) {
    self.timeoutsMade++;
    self.scheduleFunction(self.timeoutsMade, funcToCall, millis, true);
    return self.timeoutsMade;
  };

  self.clearTimeout = function(timeoutKey) {
    self.scheduledFunctions[timeoutKey] = undefined;
  };

  self.clearInterval = function(timeoutKey) {
    self.scheduledFunctions[timeoutKey] = undefined;
  };

};

jasmine.FakeTimer.prototype.reset = function() {
  this.timeoutsMade = 0;
  this.scheduledFunctions = {};
  this.nowMillis = 0;
};

jasmine.FakeTimer.prototype.tick = function(millis) {
  var oldMillis = this.nowMillis;
  var newMillis = oldMillis + millis;
  this.runFunctionsWithinRange(oldMillis, newMillis);
  this.nowMillis = newMillis;
};

jasmine.FakeTimer.prototype.runFunctionsWithinRange = function(oldMillis, nowMillis) {
  var scheduledFunc;
  var funcsToRun = [];
  for (var timeoutKey in this.scheduledFunctions) {
    scheduledFunc = this.scheduledFunctions[timeoutKey];
    if (scheduledFunc != undefined &&
        scheduledFunc.runAtMillis >= oldMillis &&
        scheduledFunc.runAtMillis <= nowMillis) {
      funcsToRun.push(scheduledFunc);
      this.scheduledFunctions[timeoutKey] = undefined;
    }
  }

  if (funcsToRun.length > 0) {
    funcsToRun.sort(function(a, b) {
      return a.runAtMillis - b.runAtMillis;
    });
    for (var i = 0; i < funcsToRun.length; ++i) {
      try {
        var funcToRun = funcsToRun[i];
        this.nowMillis = funcToRun.runAtMillis;
        funcToRun.funcToCall();
        if (funcToRun.recurring) {
          this.scheduleFunction(funcToRun.timeoutKey,
            funcToRun.funcToCall,
            funcToRun.millis,
            true);
        }
      } catch(e) {
      }
    }
    this.runFunctionsWithinRange(oldMillis, nowMillis);
  }
};

jasmine.FakeTimer.prototype.scheduleFunction = function(timeoutKey, funcToCall, millis, recurring) {
  this.scheduledFunctions[timeoutKey] = {
    runAtMillis: this.nowMillis + millis,
    funcToCall: funcToCall,
    recurring: recurring,
    timeoutKey: timeoutKey,
    millis: millis
  };
};


jasmine.Clock = {
  defaultFakeTimer: new jasmine.FakeTimer(),

  reset: function() {
    jasmine.Clock.assertInstalled();
    jasmine.Clock.defaultFakeTimer.reset();
  },

  tick: function(millis) {
    jasmine.Clock.assertInstalled();
    jasmine.Clock.defaultFakeTimer.tick(millis);
  },

  runFunctionsWithinRange: function(oldMillis, nowMillis) {
    jasmine.Clock.defaultFakeTimer.runFunctionsWithinRange(oldMillis, nowMillis);
  },

  scheduleFunction: function(timeoutKey, funcToCall, millis, recurring) {
    jasmine.Clock.defaultFakeTimer.scheduleFunction(timeoutKey, funcToCall, millis, recurring);
  },

  useMock: function() {
    var spec = jasmine.getEnv().currentSpec;
    spec.after(jasmine.Clock.uninstallMock);

    jasmine.Clock.installMock();
  },

  installMock: function() {
    jasmine.Clock.installed = jasmine.Clock.defaultFakeTimer;
  },

  uninstallMock: function() {
    jasmine.Clock.assertInstalled();
    jasmine.Clock.installed = jasmine.Clock.real;
  },

  real: {
    setTimeout: window.setTimeout,
    clearTimeout: window.clearTimeout,
    setInterval: window.setInterval,
    clearInterval: window.clearInterval
  },

  assertInstalled: function() {
    if (jasmine.Clock.installed != jasmine.Clock.defaultFakeTimer) {
      throw new Error("Mock clock is not installed, use jasmine.Clock.useMock()");
    }
  },  

  installed: null
};
jasmine.Clock.installed = jasmine.Clock.real;

window.setTimeout = function(funcToCall, millis) {
  return jasmine.Clock.installed.setTimeout.apply(this, arguments);
};

window.setInterval = function(funcToCall, millis) {
  return jasmine.Clock.installed.setInterval.apply(this, arguments);
};

window.clearTimeout = function(timeoutKey) {
  return jasmine.Clock.installed.clearTimeout.apply(this, arguments);
};

window.clearInterval = function(timeoutKey) {
  return jasmine.Clock.installed.clearInterval.apply(this, arguments);
};

/**
 * @constructor
 */
jasmine.MultiReporter = function() {
  this.subReporters_ = [];
};
jasmine.util.inherit(jasmine.MultiReporter, jasmine.Reporter);

jasmine.MultiReporter.prototype.addReporter = function(reporter) {
  this.subReporters_.push(reporter);
};

(function() {
  var functionNames = ["reportRunnerStarting", "reportRunnerResults", "reportSuiteResults", "reportSpecResults", "log"];
  for (var i = 0; i < functionNames.length; i++) {
    var functionName = functionNames[i];
    jasmine.MultiReporter.prototype[functionName] = (function(functionName) {
      return function() {
        for (var j = 0; j < this.subReporters_.length; j++) {
          var subReporter = this.subReporters_[j];
          if (subReporter[functionName]) {
            subReporter[functionName].apply(subReporter, arguments);
          }
        }
      };
    })(functionName);
  }
})();
/**
 * Holds results for a set of Jasmine spec. Allows for the results array to hold another jasmine.NestedResults
 *
 * @constructor
 */
jasmine.NestedResults = function() {
  /**
   * The total count of results
   */
  this.totalCount = 0;
  /**
   * Number of passed results
   */
  this.passedCount = 0;
  /**
   * Number of failed results
   */
  this.failedCount = 0;
  /**
   * Was this suite/spec skipped?
   */
  this.skipped = false;
  /**
   * @ignore
   */
  this.items_ = [];
};

/**
 * Roll up the result counts.
 *
 * @param result
 */
jasmine.NestedResults.prototype.rollupCounts = function(result) {
  this.totalCount += result.totalCount;
  this.passedCount += result.passedCount;
  this.failedCount += result.failedCount;
};

/**
 * Tracks a result's message.
 * @param message
 */
jasmine.NestedResults.prototype.log = function(message) {
  this.items_.push(new jasmine.MessageResult(message));
};

/**
 * Getter for the results: message & results.
 */
jasmine.NestedResults.prototype.getItems = function() {
  return this.items_;
};

/**
 * Adds a result, tracking counts (total, passed, & failed)
 * @param {jasmine.ExpectationResult|jasmine.NestedResults} result
 */
jasmine.NestedResults.prototype.addResult = function(result) {
  if (result.type != 'MessageResult') {
    if (result.items_) {
      this.rollupCounts(result);
    } else {
      this.totalCount++;
      if (result.passed) {
        this.passedCount++;
      } else {
        this.failedCount++;
      }
    }
  }
  this.items_.push(result);
};

/**
 * @returns {Boolean} True if <b>everything</b> below passed
 */
jasmine.NestedResults.prototype.__defineGetter__('passed', function() {
  return this.passedCount === this.totalCount;
});
/**
 * Base class for pretty printing for expectation results.
 */
jasmine.PrettyPrinter = function() {
  this.ppNestLevel_ = 0;
};

/**
 * Formats a value in a nice, human-readable string.
 *
 * @param value
 * @returns {String}
 */
jasmine.PrettyPrinter.prototype.format = function(value) {
  if (this.ppNestLevel_ > 40) {
    //    return '(jasmine.pp nested too deeply!)';
    throw new Error('jasmine.PrettyPrinter: format() nested too deeply!');
  }

  this.ppNestLevel_++;
  try {
    if (value === undefined) {
      this.emitScalar('undefined');
    } else if (value === null) {
      this.emitScalar('null');
    } else if (value.navigator && value.frames && value.setTimeout) {
      this.emitScalar('<window>');
    } else if (value instanceof jasmine.Matchers.Any) {
      this.emitScalar(value.toString());
    } else if (typeof value === 'string') {
      this.emitString(value);
    } else if (typeof value === 'function') {
      this.emitScalar('Function');
    } else if (typeof value.nodeType === 'number') {
      this.emitScalar('HTMLNode');
    } else if (value instanceof Date) {
      this.emitScalar('Date(' + value + ')');
    } else if (value.__Jasmine_been_here_before__) {
      this.emitScalar('<circular reference: ' + (jasmine.isArray_(value) ? 'Array' : 'Object') + '>');
    } else if (jasmine.isArray_(value) || typeof value == 'object') {
      value.__Jasmine_been_here_before__ = true;
      if (jasmine.isArray_(value)) {
        this.emitArray(value);
      } else {
        this.emitObject(value);
      }
      delete value.__Jasmine_been_here_before__;
    } else {
      this.emitScalar(value.toString());
    }
  } finally {
    this.ppNestLevel_--;
  }
};

jasmine.PrettyPrinter.prototype.iterateObject = function(obj, fn) {
  for (var property in obj) {
    if (property == '__Jasmine_been_here_before__') continue;
    fn(property, obj.__lookupGetter__(property) != null);
  }
};

jasmine.PrettyPrinter.prototype.emitArray = jasmine.unimplementedMethod_;
jasmine.PrettyPrinter.prototype.emitObject = jasmine.unimplementedMethod_;
jasmine.PrettyPrinter.prototype.emitScalar = jasmine.unimplementedMethod_;
jasmine.PrettyPrinter.prototype.emitString = jasmine.unimplementedMethod_;

jasmine.StringPrettyPrinter = function() {
  jasmine.PrettyPrinter.call(this);

  this.string = '';
};
jasmine.util.inherit(jasmine.StringPrettyPrinter, jasmine.PrettyPrinter);

jasmine.StringPrettyPrinter.prototype.emitScalar = function(value) {
  this.append(value);
};

jasmine.StringPrettyPrinter.prototype.emitString = function(value) {
  this.append("'" + value + "'");
};

jasmine.StringPrettyPrinter.prototype.emitArray = function(array) {
  this.append('[ ');
  for (var i = 0; i < array.length; i++) {
    if (i > 0) {
      this.append(', ');
    }
    this.format(array[i]);
  }
  this.append(' ]');
};

jasmine.StringPrettyPrinter.prototype.emitObject = function(obj) {
  var self = this;
  this.append('{ ');
  var first = true;

  this.iterateObject(obj, function(property, isGetter) {
    if (first) {
      first = false;
    } else {
      self.append(', ');
    }

    self.append(property);
    self.append(' : ');
    if (isGetter) {
      self.append('<getter>');
    } else {
      self.format(obj[property]);
    }
  });

  this.append(' }');
};

jasmine.StringPrettyPrinter.prototype.append = function(value) {
  this.string += value;
};
/**
 * QueuedFunction is how ActionCollections' actions are implemented
 *
 * @constructor
 * @param {jasmine.Env} env
 * @param {Function} func
 * @param {Number} timeout
 * @param {Function} latchFunction
 * @param {jasmine.Spec} spec
 */
jasmine.QueuedFunction = function(env, func, timeout, latchFunction, spec) {
  this.env = env;
  this.func = func;
  this.timeout = timeout;
  this.latchFunction = latchFunction;
  this.spec = spec;

  this.totalTimeSpentWaitingForLatch = 0;
  this.latchTimeoutIncrement = 100;
};

jasmine.QueuedFunction.prototype.next = function() {
  this.spec.finish(); // default value is to be done after one function
};

jasmine.QueuedFunction.prototype.safeExecute = function() {
  this.env.reporter.log('>> Jasmine Running ' + this.spec.suite.description + ' ' + this.spec.description + '...');

  try {
    this.func.apply(this.spec);
  } catch (e) {
    this.fail(e);
  }
};

jasmine.QueuedFunction.prototype.execute = function() {
  var self = this;
  var executeNow = function() {
    self.safeExecute();
    self.next();
  };

  var executeLater = function() {
    self.env.setTimeout(executeNow, self.timeout);
  };

  var executeNowOrLater = function() {
    var latchFunctionResult;

    try {
      latchFunctionResult = self.latchFunction.apply(self.spec);
    } catch (e) {
      self.fail(e);
      self.next();
      return;
    }

    if (latchFunctionResult) {
      executeNow();
    } else if (self.totalTimeSpentWaitingForLatch >= self.timeout) {
      var message = 'timed out after ' + self.timeout + ' msec waiting for ' + (self.latchFunction.description || 'something to happen');
      self.fail({
        name: 'timeout',
        message: message
      });
      self.next();
    } else {
      self.totalTimeSpentWaitingForLatch += self.latchTimeoutIncrement;
      self.env.setTimeout(executeNowOrLater, self.latchTimeoutIncrement);
    }
  };

  if (this.latchFunction !== undefined) {
    executeNowOrLater();
  } else if (this.timeout > 0) {
    executeLater();
  } else {
    executeNow();
  }
};

jasmine.QueuedFunction.prototype.fail = function(e) {
  this.spec.results.addResult(new jasmine.ExpectationResult(false, jasmine.util.formatException(e), null));
};
/* JasmineReporters.reporter
 *    Base object that will get called whenever a Spec, Suite, or Runner is done.  It is up to
 *    descendants of this object to do something with the results (see json_reporter.js)
 */
jasmine.Reporters = {};

jasmine.Reporters.reporter = function(callbacks) {
  var that = {
    callbacks: callbacks || {},

    doCallback: function(callback, results) {
      if (callback) {
        callback(results);
      }
    },

    reportRunnerResults: function(runner) {
      that.doCallback(that.callbacks.runnerCallback, runner);
    },
    reportSuiteResults:  function(suite) {
      that.doCallback(that.callbacks.suiteCallback, suite);
    },
    reportSpecResults:   function(spec) {
      that.doCallback(that.callbacks.specCallback, spec);
    },
    log: function (str) {
      if (console && console.log) console.log(str);
    }
  };

  return that;
};

/**
 * Runner
 *
 * @constructor
 * @param {jasmine.Env} env
 */
jasmine.Runner = function(env) {
  jasmine.ActionCollection.call(this, env);

  this.suites = this.actions;
};
jasmine.util.inherit(jasmine.Runner, jasmine.ActionCollection);

jasmine.Runner.prototype.execute = function() {
  if (this.env.reporter.reportRunnerStarting) {
    this.env.reporter.reportRunnerStarting(this);
  }
  jasmine.ActionCollection.prototype.execute.call(this);
};

jasmine.Runner.prototype.finishCallback = function() {
  this.env.reporter.reportRunnerResults(this);
};

jasmine.Runner.prototype.getResults = function() {
  var results = new jasmine.NestedResults();
  for (var i = 0; i < this.suites.length; i++) {
    results.rollupCounts(this.suites[i].getResults());
  }
  return results;
};
/**
 * Internal representation of a Jasmine specification, or test.
 *
 * @constructor
 * @param {jasmine.Env} env
 * @param {jasmine.Suite} suite
 * @param {String} description
 */
jasmine.Spec = function(env, suite, description) {
  this.id = env.nextSpecId_++;
  this.env = env;
  this.suite = suite;
  this.description = description;
  this.queue = [];
  this.currentTimeout = 0;
  this.currentLatchFunction = undefined;
  this.finished = false;
  this.afterCallbacks = [];
  this.spies_ = [];

  this.results = new jasmine.NestedResults();
  this.results.description = description;
  this.runs = this.addToQueue;
  this.matchersClass = null;
};

jasmine.Spec.prototype.getFullName = function() {
  return this.suite.getFullName() + ' ' + this.description + '.';
};

jasmine.Spec.prototype.getResults = function() {
  return this.results;
};

jasmine.Spec.prototype.addToQueue = function(func) {
  var queuedFunction = new jasmine.QueuedFunction(this.env, func, this.currentTimeout, this.currentLatchFunction, this);
  this.queue.push(queuedFunction);

  if (this.queue.length > 1) {
    var previousQueuedFunction = this.queue[this.queue.length - 2];
    previousQueuedFunction.next = function() {
      queuedFunction.execute();
    };
  }

  this.resetTimeout();
  return this;
};

/**
 * @private
 * @deprecated
 */
jasmine.Spec.prototype.expects_that = function(actual) {
  return this.expect(actual);
};

/**
 * @private
 */
jasmine.Spec.prototype.expect = function(actual) {
  return new (this.getMatchersClass_())(this.env, actual, this.results);
};

/**
 * @private
 */
jasmine.Spec.prototype.waits = function(timeout) {
  this.currentTimeout = timeout;
  this.currentLatchFunction = undefined;
  return this;
};

/**
 * @private
 */
jasmine.Spec.prototype.waitsFor = function(timeout, latchFunction, message) {
  this.currentTimeout = timeout;
  this.currentLatchFunction = latchFunction;
  this.currentLatchFunction.description = message;
  return this;
};

jasmine.Spec.prototype.getMatchersClass_ = function() {
  return this.matchersClass || jasmine.Matchers;
};

jasmine.Spec.prototype.addMatchers = function(matchersPrototype) {
  var parent = this.getMatchersClass_();
  var newMatchersClass = function() {
    parent.apply(this, arguments);
  };
  jasmine.util.inherit(newMatchersClass, parent);
  for (var method in matchersPrototype) {
    newMatchersClass.prototype[method] = matchersPrototype[method];
  }
  this.matchersClass = newMatchersClass;
};

jasmine.Spec.prototype.resetTimeout = function() {
  this.currentTimeout = 0;
  this.currentLatchFunction = undefined;
};

jasmine.Spec.prototype.finishCallback = function() {
  this.env.reporter.reportSpecResults(this);
};

jasmine.Spec.prototype.finish = function() {
  this.safeExecuteAfters();

  this.removeAllSpies();
  this.finishCallback();
  this.finished = true;
};

jasmine.Spec.prototype.after = function(doAfter) {
  this.afterCallbacks.unshift(doAfter);
};

jasmine.Spec.prototype.execute = function() {
  if (!this.env.specFilter(this)) {
    this.results.skipped = true;
    this.finishCallback();
    this.finished = true;
    return;
  }

  this.env.currentSpec = this;
  this.env.currentlyRunningTests = true;

  this.safeExecuteBefores();

  if (this.queue[0]) {
    this.queue[0].execute();
  } else {
    this.finish();
  }
  this.env.currentlyRunningTests = false;
};

jasmine.Spec.prototype.safeExecuteBefores = function() {
  var befores = [];
  for (var suite = this.suite; suite; suite = suite.parentSuite) {
    if (suite.beforeEachFunction) befores.push(suite.beforeEachFunction);
  }

  while (befores.length) {
    this.safeExecuteBeforeOrAfter(befores.pop());
  }
};

jasmine.Spec.prototype.safeExecuteAfters = function() {
  for (var suite = this.suite; suite; suite = suite.parentSuite) {
    if (suite.afterEachFunction) this.safeExecuteBeforeOrAfter(suite.afterEachFunction);
  }
};

jasmine.Spec.prototype.safeExecuteBeforeOrAfter = function(func) {
  try {
    func.apply(this);
  } catch (e) {
    this.results.addResult(new jasmine.ExpectationResult(false, func.typeName + '() fail: ' + jasmine.util.formatException(e), null));
  }
};

jasmine.Spec.prototype.explodes = function() {
  throw 'explodes function should not have been called';
};

jasmine.Spec.prototype.spyOn = function(obj, methodName, ignoreMethodDoesntExist) {
  if (obj == undefined) {
    throw "spyOn could not find an object to spy upon for " + methodName + "()";
  }

  if (!ignoreMethodDoesntExist && obj[methodName] === undefined) {
    throw methodName + '() method does not exist';
  }

  if (!ignoreMethodDoesntExist && obj[methodName] && obj[methodName].isSpy) {
    throw new Error(methodName + ' has already been spied upon');
  }

  var spyObj = jasmine.createSpy(methodName);

  this.spies_.push(spyObj);
  spyObj.baseObj = obj;
  spyObj.methodName = methodName;
  spyObj.originalValue = obj[methodName];

  obj[methodName] = spyObj;

  return spyObj;
};

jasmine.Spec.prototype.removeAllSpies = function() {
  for (var i = 0; i < this.spies_.length; i++) {
    var spy = this.spies_[i];
    spy.baseObj[spy.methodName] = spy.originalValue;
  }
  this.spies_ = [];
};

/**
 * Internal representation of a Jasmine suite.
 *
 * @constructor
 * @param {jasmine.Env} env
 * @param {String} description
 * @param {Function} specDefinitions
 * @param {jasmine.Suite} parentSuite
 */
jasmine.Suite = function(env, description, specDefinitions, parentSuite) {
  jasmine.ActionCollection.call(this, env);
  
  this.id = env.nextSuiteId_++;
  this.description = description;
  this.specs = this.actions;
  this.parentSuite = parentSuite;

  this.beforeEachFunction = null;
  this.afterEachFunction = null;
};
jasmine.util.inherit(jasmine.Suite, jasmine.ActionCollection);

jasmine.Suite.prototype.getFullName = function() {
  var fullName = this.description;
  for (var parentSuite = this.parentSuite; parentSuite; parentSuite = parentSuite.parentSuite) {
    fullName = parentSuite.description + ' ' + fullName;
  }
  return fullName;
};

jasmine.Suite.prototype.finishCallback = function() {
  this.env.reporter.reportSuiteResults(this);
};

jasmine.Suite.prototype.beforeEach = function(beforeEachFunction) {
  beforeEachFunction.typeName = 'beforeEach';
  this.beforeEachFunction = beforeEachFunction;
};

jasmine.Suite.prototype.afterEach = function(afterEachFunction) {
  afterEachFunction.typeName = 'afterEach';
  this.afterEachFunction = afterEachFunction;
};

jasmine.Suite.prototype.getResults = function() {
  var results = new jasmine.NestedResults();
  results.description = this.description;
  results.id = this.id;
  
  for (var i = 0; i < this.specs.length; i++) {
    results.rollupCounts(this.specs[i].getResults());
  }
  return results;
};

