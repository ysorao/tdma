var EspecialistaTelederma = {
  
  initialize: function(){

    var module = angular.module('especialistatelederma', ['consult-module', 'admin_ips-module', 'nurse_consult-module']);

    document.addEventListener("turbolinks:load", function() {
      var element = angular.element(document.querySelector('body'));

      var isInitialized = element.injector();
      if (!isInitialized) {
        angular.bootstrap(document.body, ['especialistatelederma'])
      }
    });

    module.directive('ngFocusIf', ["$timeout", function($timeout) {
      return {
        restrict: 'A',
        link: function(scope, element, attrs) {
          console.log("IN FOCUS DIR: ");
          console.log("ELEMENT: ");
          console.log(element);
          console.log("ATTRS: ");
          console.log(attrs);
          console.log("______");
          ;
          if(scope.$eval(attrs['ngFocusIf'])) {
            $timeout(function () {
              element.focus();
            }, 0);
          }
        }
      };
    }]);

    module.directive("ngFileSelect", function(fileReader, $timeout) {
      return {
        scope: {
          ngModel: '='
        },
        link: function($scope, el) {
          function getFile(file) {
            fileReader.readAsDataUrl(file, $scope)
            .then(function(result) {
              $timeout(function() {
                $scope.ngModel = result;
              });
            });
          }

          el.bind("change", function(e) {
            var file = (e.srcElement || e.target).files[0];
            getFile(file);
          });
        }
      };
    });

    module.filter('pagination', function(){
      return function(input, start)
      {
        start = +start;
        return input.slice(start);
      };
    });

    module.filter('ceil', function () {
      return function (value) {
        return Math.ceil(value);
      };
    })

    module.filter('parseInt', function() {
      return function(number) {
        if(!number) {
          return false;
        }
        return parseInt(number , 10);
      };
    })


    module.filter('myCurrency', ['$filter', function ($filter) {
      return function(input) {
        input = parseFloat(input);

        if(input % 1 === 0) {
          input = input.toFixed(0);
        }
        else {
          input = input.toFixed(2);
        }

        return '$' + input.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
      };
    }]);

    module.factory("fileReader", function($q, $log) {
      var onLoad = function(reader, deferred, scope) {
        return function() {
          scope.$apply(function() {
            deferred.resolve(reader.result);
          });
        };
      };

      var onError = function(reader, deferred, scope) {
        return function() {
          scope.$apply(function() {
            deferred.reject(reader.result);
          });
        };
      };

      var onProgress = function(reader, scope) {
        return function(event) {
          scope.$broadcast("fileProgress", {
            total: event.total,
            loaded: event.loaded
          });
        };
      };

      var getReader = function(deferred, scope) {
        var reader = new FileReader();
        reader.onload = onLoad(reader, deferred, scope);
        reader.onerror = onError(reader, deferred, scope);
        reader.onprogress = onProgress(reader, scope);
        return reader;
      };

      var readAsDataURL = function(file, scope) {
        var deferred = $q.defer();

        var reader = getReader(deferred, scope);
        reader.readAsDataURL(file);

        return deferred.promise;
      };

      return {
        readAsDataUrl: readAsDataURL
      };
    });

    module.directive('onLastRepeat', function() {
      return function(scope, element, attrs) {
        if (scope.$last) setTimeout(function(){
          scope.$emit('onRepeatLast', element, attrs);
        }, 1);
      };
    });

    module.directive(
      "repeatComplete",
      function( $rootScope ) {

        // Because we can have multiple ng-repeat directives in
        // the same container, we need a way to differentiate
        // the different sets of elements. We'll add a unique ID
        // to each set.
        var uuid = 0;


        // I compile the DOM node before it is linked by the
        // ng-repeat directive.
        function compile( tElement, tAttributes ) {

          // Get the unique ID that we'll be using for this
          // particular instance of the directive.
          var id = ++uuid;

          // Add the unique ID so we know how to query for
          // DOM elements during the digests.
          tElement.attr( "repeat-complete-id", id );

          // Since this directive doesn't have a linking phase,
          // remove it from the DOM node.
          tElement.removeAttr( "repeat-complete" );

          // Keep track of the expression we're going to
          // invoke once the ng-repeat has finished
          // rendering.
          var completeExpression = tAttributes.repeatComplete;

          // Get the element that contains the list. We'll
          // use this element as the launch point for our
          // DOM search query.
          var parent = tElement.parent();

          // Get the scope associated with the parent - we
          // want to get as close to the ngRepeat so that our
          // watcher will automatically unbind as soon as the
          // parent scope is destroyed.
          var parentScope = ( parent.scope() || $rootScope );

          // Since we are outside of the ng-repeat directive,
          // we'll have to check the state of the DOM during
          // each $digest phase; BUT, we only need to do this
          // once, so save a referene to the un-watcher.
          var unbindWatcher = parentScope.$watch(
            function() {

              console.info( "Digest running." );

              // Now that we're in a digest, check to see
              // if there are any ngRepeat items being
              // rendered. Since we want to know when the
              // list has completed, we only need the last
              // one we can find.
              var lastItem = parent.children( "*[ repeat-complete-id = '" + id + "' ]:last" );

              // If no items have been rendered yet, stop.
              if ( ! lastItem.length ) {

                return;

              }

              // Get the local ng-repeat scope for the item.
              var itemScope = lastItem.scope();

              // If the item is the "last" item as defined
              // by the ng-repeat directive, then we know
              // that the ng-repeat directive has finished
              // rendering its list (for the first time).
              if ( itemScope.$last ) {

                // Stop watching for changes - we only
                // care about the first complete rendering.
                unbindWatcher();

                // Invoke the callback.
                itemScope.$eval( completeExpression );

              }

            }
          );

        }

        // Return the directive configuration. It's important
        // that this compiles before the ngRepeat directive
        // compiles the DOM node.
        return({
          compile: compile,
          priority: 1001,
          restrict: "A"
        });

      }
    );
  }
}