scrummer.directive('menu', ['projectFactory', '$location', function() {

  return {
    restrict: 'E',
    templateUrl: 'menu.html',
    controllerAs: 'Project',
    replace: true,
    scope: {
      project: '=',
    },
    link: function($scope, $element) {},
    controller: function($scope, $element, projectFactory, $location) {

      var project = this;
      projectFactory.index()
      .success(function(data) {
        project.projects = data.document.projects;
      });
      
      if ($location.path()) {
        var indexOfProjectID = $location.path().split("/").indexOf("projects") + 1
        var projectID = indexOfProjectID > 0 ? location.hash.split("/")[indexOfProjectID] : null
        project.activeProjectID = parseInt(projectID)
      }
      

    }

  };
}]);