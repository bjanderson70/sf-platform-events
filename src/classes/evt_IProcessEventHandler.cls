public interface evt_IProcessEventHandler {

	Object process(Object parameter, evt_PlatformEventAttrs attributes);
	
	// getter/setter or the process event handler name (properties !!!)
	String handlerName();
	void handlerName(String name);
}