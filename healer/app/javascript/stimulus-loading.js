export function eagerLoadControllersFrom(context, application) {
  Object.entries(context).forEach(([identifier, controller]) => {
    application.register(identifier, controller);
  });
}
