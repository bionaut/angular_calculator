######################################
# smartSlider Module  ################
######################################
# Universal multifunctional slider ###
######################################



angular
        .module 'smartSlider.module', []
          
        # mouse service for detecting mouse events
        .factory 'mouseService', ($window, $rootScope) ->
          
          # element with mousedown event
          selected = null
          sId = null

          # listeners
          angular.element($window).on 'mouseup', (ev) ->
            $rootScope.$broadcast 'selectedreleased'
            selected = null
            sId = null
          angular.element($window).on 'mousemove', (ev) ->
            if selected
              $rootScope.$broadcast 'moveselected', ev.pageX
              
          
          # return
          selected: (element, id) ->
            if element?
              sId = id
              return selected = element
            else
              return [selected, sId]



        # MAIN DIRECTIVE
        .directive 'smartSlider', (mouseService) ->
          scope:
            min: '='
            max: '='
            step: '='
            current: '='
            limits: '=?'
            sections: '=?'
            # barTooltip: '=?'

          restrict: 'E'
          templateUrl: "vendor/smart_slider/smart_slider.html"
          replace: true

          controller: ($scope, $element, $timeout) ->
            
            s = $scope

            # window events listener
            s.$on 'moveselected', (ev, pageX) ->
              if s.$id == mouseService.selected()[1]
                # define elements
                targetScope = ev.targetScope
                handle = mouseService.selected()[0]
                wrap = handle.parent()
                # get wrapper offset
                offset = s.getOffset(wrap)
                offset.percentage = offset.width / 100
                percInPx = ( (pageX - offset.left) / offset.percentage)
                # apply new value based on handle position
                s.current = s.getValueOfPercentage(percInPx, offset)
                s.$apply()


            # backup $watcher which keeps the values in the defined range
            s.$watch 'current', (n) ->
              if n < s.min then s.current = s.min
              if n > s.max then s.current = s.max
          


            # f() for rounding numbers
            s.roundNum = (number, increment, offset) ->
              Math.round((number - offset) / increment) * increment + offset

            # f() for getting offset of an element in !pixels!
            s.getOffset = (element) ->
              offset = element.get(0).getBoundingClientRect()
              return offset
            

            # helper methods
            s.getPercentage = (n) ->
              onePerc = (s.max - s.min) / 100
              return ( (n-s.min) / onePerc ) + "%"
            s.getValueOfPercentage = (perc, offset) ->
              range = s.max - s.min
              if offset?
                return s.roundNum(((perc / 100) * range) + s.min, s.step, 0)
            s.goTo = (value) ->
              if value?
                s.current = value
              return

            # slider buttons methods
            s.add = (step) ->
              s.current += step
              if s.current > s.max
                s.current = s.max
            s.subtract = (step) ->
              s.current -= step
              if s.current < s.min
                s.current = s.min

            # init slider breakpoints
            s.$watch 'current', (n,o) ->
              # tu bude nejake undefined
              if o!=undefined or n!=undefined and s.sections and s.breakpoints == undefined
                s.breakpoints = []
                stepDif = s.max / s.sections
                for num in [1..s.sections]
                  if (num*stepDif) > s.min
                    s.breakpoints.push s.roundNum (stepDif * num), s.step, 0
            
        
        .directive 'stopPropagation', () ->
          return (s,e,a) ->
            e.on 'click mousedown', (e) ->
              e.stopPropagation()
            


        # directive helper that returns percentage after click
        .directive 'detectClick', () ->
          return (s,e,a) ->
            e.on 'click', (ev) ->
              offset = s.getOffset(e)
              offset.percentage = offset.width / 100
              percInPx = ( (ev.pageX - offset.left) / offset.percentage)
              s.current = s.getValueOfPercentage(percInPx, offset)
              s.$apply()

            # e.on 'mousemove', () ->
              # doriestit placeholder?
            
        
        # slider handle directive
        .directive 'smartHandle', (mouseService, $rootScope) ->
          return (s,e,a) ->
            
            e.on 'mousedown', (ev) ->
              ev.stopPropagation()
              
              # send object & s.$id to service
              mouseService.selected(e, s.$id)
              s.$apply()


            # if angular.isObject($scope.barTooltip)
            # $scope.barTooltip = (params) ->
            #   if angular.isObject(params)
            #     console.log 'je to objekt'
            
            
            