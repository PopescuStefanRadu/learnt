# Angular

html attribute, dom property



When the component is registered, it creates a component factory class and stores it for later use.

The default change-detection algorithm looks for differences by comparing
bound-property values by reference across change detection runs. You can use this
hook to check for and respond to changes by some other means.

\<ng-content> <- insertion point
\<myComponent>\<p\>Hello world\</p>\<myComponent>


ng-container -> basic container stuff for ngIf and whatnot

ng-template -> just a template to apply directives to

ng-content -> content projection

template reference -> \# 


Change detection: default = everything with input, OnPush = only if parent changed

OnPush refers only to changes coming from parent component on input. Rest still take effect.


ngOnChanges receives changes on inputs as an object: changes.field1, changes.field2 etc.
ngOnChanges is ran after to @Input() annotated properties


DoCheck - check for changes that angular cannot detect automatically


@ViewChild -> reference to component from template with same name \(#)

NgModule - entryComponents: components that need to be rendered dynamically. ???? more on this later\(page 107)

see ViewContainerRef/ViewChild/ComponentFactoryResolver



## Injection:

 - alias \(useExisting) - doesn't create new instance
 - Class \(useClass) - creates new instance
 - Factory \(useFactory, deps) - factory with deps
 - Value \(inject value)

multi-provider \(multi) - add extra instance but inject all of them

`NgModule` import order counts, because the `Injectable`s get registered into the same `Injector`, so if there is a conflict for a `InjectionToken`, the latest is kept, while the previous is discarded. Effectively `map.put()`



router - can nest router outlets using child routes

secondary routers - use outlets


Route guards:

 - CanActivate - Used to determine whether the route can be activated (such as
   user validation)
 - CanActivateChild - Same as CanActivate, but specifically for child routes
 - CanDeactivate - Used to determine whether the current route can be deactivated
   \(such as preventing leaving an unsaved form without confirmation)
 - CanLoad - Used to determine whether the user can navigate to a lazy loaded
   module prior to loading it
 - Resolve -  Used to access route data and pass data to the component's list of
   providers



Creating libraries:

Local dev solutions:

 - monorepo
 - npm registry local
 - npm link
 - tsconfig pointing towards dist (`ng-packagr` used by libs compiles 
differently from @angular-devkit/build-angular so always point to dist js files)


## Misc notes from learnt.md

 - package json
 - ng serve - run
 - npm install --save bootstrap@3 (local, cea mai noua din v3)
 - angular.json -> styles
 - typescript - use single quotes
 - binding 
    - ts -> template: string interpolation; attribute/property binding??
    - html -> ts : event binding
    - ngModel
 - * - directiva structurala??? TODO
 - ng generate component shoes/shoe-edit /// ng g c // --spec=false
 - var str: string; var qty = +str; //conversion to number
 - @ViewChild - ajungi sa faci din component un Session Managed Bean a la JSF
 - ng-content + @ContentChild() pt cand vreau ca directiva sa foloseasca ce 
este in interiorul <app-component-name></app-component-name>
 - https://github.com/angular/angular-cli/blob/v6.0.0-rc.8/packages/%40angular/cli/lib/config/schema.json - angular-ci options for serve, etc.
 - https://github.com/angular/angular-cli/wiki/angular-workspace angular cli schema
