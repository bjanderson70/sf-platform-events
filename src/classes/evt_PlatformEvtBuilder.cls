/**
 * Encapsulates all behaviour logic relating to the
 *
 * For more guidelines and details see
 *   https://developer.salesforce.com/page/Apex_Enterprise_Patterns_-_Domain_Layer
 * @group Domain Layer
 **/
/**
 * Copyright (c) 2016-2018, Bill Anderson.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *
 *   * Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in
 *     the documentation and/or other materials provided with the
 *     distribution.
 *
 *   * Neither the name of Bill Anderson nor the names of its
 *     contributors may be used to endorse or promote products derived
 *     from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 *
 * @author Bill Anderson
 * @description platform event publisher/consumer builder
 * NOTE: This class does too much -- refactor!
 * @group Common Layer
 */

public without sharing class evt_PlatformEvtBuilder {


	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// Data Members
	//
	/////////////////////////////////////////////////////////////////////////////////////////

	@TestVisible
	enum PubSubType { CONSUMER, PUBLISHER}
	@TestVisible
	boolean m_isActiveEvent = true;
	@TestVisible
	boolean m_isBadEventName = false;
	@TestVisible
	string m_eventName = null;
	@TestVisible
	string m_environment = null;
	@TestVisible
	List<evt_PlatformEvtMdtDataModel.PEDataModelInformation> m_elements = null;

	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// Ctors
	//
	/////////////////////////////////////////////////////////////////////////////////////////
	/**
	 * @brief ctor
	 * @description ctor
	 *
	 */
	public evt_PlatformEvtBuilder(string theEventName) {
		// look for event in the production (custom metadata) environment
		this(theEventName, evt_PlatformEvtUtilities.PROD_ENVIRONMENT);
	} // end of ctor
	/**
	 * @description ctor
	 * 
	 * @param theEventName the event name
	 * @param enviroment environment to look for the event in the custom metadata
	 * 
	 */
	public evt_PlatformEvtBuilder(string theEventName, string enviroment) {

		this.eventName = theEventName;
		// what type of environment (test, debug, prod)?
		this.eventEnvironment = evt_PlatformEvtUtilities.ensureEnviromentIsCorrectOtherwiseDebug(enviroment);
		// here we go read the custom metadata information
		this.m_elements =  (new evt_PlatformEvtMdtDataModel()).findByEnvironmentAndLabel(this.m_environment, this.m_eventName);
		// check for later
		this.validEventName = evt_PlatformEvtUtilities.validEventName(this.m_eventName) == false;
		// is this event active
		this.eventActive = evt_PlatformEvtBuilder.isEventActive(this.m_elements);
	} // end of ctor

	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// Public Properties
	//
	/////////////////////////////////////////////////////////////////////////////////////////
	/**
	 * is the event name valid
	 */
	public Boolean validEventName {
		get { return this.m_isBadEventName;}
		private set { this.m_isBadEventName = value;}
	} // end of validEventName
	/**
	 * is the event active
	 */
	public Boolean eventActive {
		get { return this.m_isActiveEvent;}
		private set {this.m_isActiveEvent = value;}
	} // end of eventActive
	/**
	 * The event name
	 */
	public String eventName {
		get { return this.m_eventName;}
		private set { this.m_eventName = value;}
	} // end of eventName
	/**
	 * The event environment
	 */
	public String eventEnvironment {
		get { return this.m_environment;}
		private set { this.m_environment = value;}
	} // end of eventEnvironment
	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// Public Methods
	//
	/////////////////////////////////////////////////////////////////////////////////////////
	/**
	* @description build the event consumer
	*
	* @return the event consumer
	*/
	public virtual evt_IEventHandler buildConsumer() {
		// build pub/sub handlers
		return  evt_PlatformEvtBuilder.buildEventHandler(this.m_elements, null, this.m_eventName, PubSubType.CONSUMER);
	}
	/**
	* @description build the event publisher
	*
	* @return the event publisher
	*/
	public virtual evt_IEventHandler buildPublisher() {
		// build pub/sub handlers
		return  evt_PlatformEvtBuilder.buildEventHandler(this.m_elements, null, this.m_eventName, PubSubType.PUBLISHER);
	}
	/**
	* @description build the event model
	*
	* @return the event model
	*/
	public virtual evt_IPlatformEventModel build() {
		return this.build(null, null, null);
	}
	/**
	 * @description build the event model
	 *
	 * @param attributes attributes controlling behavior
	 * @return the event model
	 */
	public virtual evt_IPlatformEventModel build(evt_PlatformEventAttrs attributes) {
		return this.build(null, null, attributes);
	}
	/**
	* @description build the event model
	*
	* @param thePublisherConsumer publisher or consumer
	* @return the event model
	*/
	public virtual evt_IPlatformEventModel build(evt_IEventHandler thePublisherConsumer) {
		return this.build(thePublisherConsumer, null, null);
	}
	/**
	* @description build the event model
	*
	* @param thePublisherConsumer publisher or consumer
	* @param attributes attributes controlling behavior
	* @return the event model
	*/
	public virtual evt_IPlatformEventModel build(evt_IEventHandler thePublisherConsumer, evt_PlatformEventAttrs attributes) {
		return this.build(thePublisherConsumer, null, attributes);
	}
	/**
	 * @description build the event model
	 *
	 * @param thePublisherConsumer publisher or consumer
	 * @param handlers the log, success, error, alert handlers
	 * @param attributes attributes controlling behavior
	 * @return the event model
	 */
	public virtual evt_IPlatformEventModel build(evt_IEventHandler thePublisherConsumer, evt_IProcessEventHandlers handlers, evt_PlatformEventAttrs attributes) {

		evt_PlatformEventAttrs l_attributes = attributes == null ? new evt_PlatformEventAttrs() : attributes;
		// build pub/sub handlers
		evt_IEventHandler pubsub = evt_PlatformEvtBuilder.buildEventHandler(this.m_elements, thePublisherConsumer, this.m_eventName, PubSubType.PUBLISHER);
		// build handlers
		evt_IProcessEventHandlers myHandlers = evt_PlatformEvtBuilder.buildProcessHandlers(this.m_elements, handlers);

		// we throw an exception if the event name is not found
		// and the attributes indicate us to throw
		if ( this.m_isBadEventName  && l_attributes.checkEvent() ) {
			throw new evt_PlatformEventException('Platform Event is not found, check spelling [' + this.m_eventName + ']');
		}

		return new evt_DefaultPlatformEventModel(pubsub, myHandlers, l_attributes);
	} // end of build


	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// Private Methods
	//
	/////////////////////////////////////////////////////////////////////////////////////////
	/**
	 * @description build the event handler (consumer / publisher )
	 *
	 * @param elements custom metadata
	 * @param thePublisherConsumer the publisher or consumer, if known; otherwise will create default publisher
	 * @param psType Type of event handler ( publisher or consumer )
	 * @return evt_IEventHandler ( publisher or consumer )
	 */
	@TestVisible
	static evt_IEventHandler buildEventHandler(List<evt_PlatformEvtMdtDataModel.PEDataModelInformation> elements
	        , evt_IEventHandler thePublisherConsumer
	        , String theEventName
	        , PubSubType psType) {

		evt_IEventHandler result = thePublisherConsumer;
		evt_PlatformEvtMdtDataModel.PEDataModelInformation element = elements != null && elements.size() > 0 ? elements[0] : null;
		if ( result == null ) {
			if ( element != null ) {
				String index = evt_PlatformEvtBuilder.getEventHandlerValue(element, psType);
				result = evt_PlatformEvtBuilder.createEventHandler(index, theEventName, element.serializeEvent);
			}
		}


		return result;
	} // end of buildEventHandler

	/**
	 * @description  build the process container, look at user input, and then look at custom metadata, if needed
	 *
	 * @param elements custom metadata holder of known handlers
	 * @param handlers user passed in handlers
	 *
	 * @return instance of a process handler container
	 */
	@TestVisible
	static evt_IProcessEventHandlers buildProcessHandlers(List<evt_PlatformEvtMdtDataModel.PEDataModelInformation> elements
	        , evt_IProcessEventHandlers handlers) {
		
		evt_PlatformEvtMdtDataModel.PEDataModelInformation element = elements != null && elements.size() > 0 ? elements[0] : null;
		evt_IProcessEventHandlers result = handlers;
		if ( result == null ) {
			result = evt_PlatformEvtBuilder.createProcessHandlers(element);
		}
		return result;
	} // end of buildProcessHandlers

	/**
	 * @description create the process handler container
	 *
	 * @param elements custom metadata of the handlers
	 * @return instance of a process handler container
	 */
	@TestVisible
	static evt_IProcessEventHandlers createProcessHandlers(evt_PlatformEvtMdtDataModel.PEDataModelInformation elements) {

		Map<String, evt_IProcessEventHandler> instances = new Map<String, evt_IProcessEventHandler>  {
			evt_DefaultProcessEventHandlers.SUCCESS_HANDLER_s => evt_PlatformEvtBuilder.createProcessHandler(elements == null ? null : elements.successHandlerClass
			, evt_DefaultProcessEventHandlers.SUCCESS_HANDLER_s),
			evt_DefaultProcessEventHandlers.LOG_HANDLER_s => evt_PlatformEvtBuilder.createProcessHandler(elements == null ? null : elements.logHandlerClass
			, evt_DefaultProcessEventHandlers.LOG_HANDLER_s),
			evt_DefaultProcessEventHandlers.ERROR_HANDLER_s => evt_PlatformEvtBuilder.createProcessHandler(elements == null ? null : elements.errorHandlerClass
			, evt_DefaultProcessEventHandlers.ERROR_HANDLER_s),
			evt_DefaultProcessEventHandlers.ALERT_HANDLER_s => evt_PlatformEvtBuilder.createProcessHandler(elements == null ? null : elements.alertHandlerClass
			, evt_DefaultProcessEventHandlers.ALERT_HANDLER_s)
		};

		return new evt_DefaultProcessEventHandlers(
		           instances.get(evt_DefaultProcessEventHandlers.LOG_HANDLER_s)
		           , instances.get(evt_DefaultProcessEventHandlers.ERROR_HANDLER_s)
		           , instances.get(evt_DefaultProcessEventHandlers.SUCCESS_HANDLER_s)
		           , instances.get(evt_DefaultProcessEventHandlers.ALERT_HANDLER_s)
		       );

	} // end of createProcessHandlers
	/**
	* @description create the process handler from the FQDN (the default is a publisher)
	*
	* @param fqdn fully qualified domain name
	* @param theEventName the event name
	* @param serializeEvent serialize the event
	*
	* @return instance of a event handler (i.e. publisher or consumer)
	*/
	@TestVisible
	static evt_IEventHandler createEventHandler(string fqdn, String theEventName, Boolean serializeEvent) {
		evt_IEventHandler result = (evt_IEventHandler) evt_PlatformEvtUtilities.getClassInstance(fqdn);

		if ( result != null ) {
			result.handlerEventName(theEventName);
			result.handlerToSerialize(serializeEvent);
		}
		return result == null ? new evt_DefaultPEPublisher(theEventName ,serializeEvent)  : result;
	}// end of createEventHandler
	/**
	 * @description create the process handler from the FQDN
	 *
	 * @param fqdn fully qualified domain name
	 * @param defaultIndex name index into known process handlers
	 *
	 * @return instance of a process handler
	 */
	@TestVisible
	static evt_IProcessEventHandler createProcessHandler(string fqdn, string defaultIndex) {
		evt_IProcessEventHandler result = (evt_IProcessEventHandler) evt_PlatformEvtUtilities.getClassInstance(fqdn);
		if ( result != null ) {
			result.handlerName(defaultIndex);
		}
		return result == null ? evt_DefaultProcessEventHandlers.defaultHandlerByName(defaultIndex) : result;
	} // end of createProcessHandler

	/**

	 * @description get the event handler name
	 *
	 * @param element data from the custom metadata
	 * @param psType enumeration, publisher or consumer
	 * @return name of the class instance
	 */
	@TestVisible
	static string getEventHandlerValue(evt_PlatformEvtMdtDataModel.PEDataModelInformation element
	                                   , PubSubType psType) {

		String name = element == null ? evt_PlatformEvtUtilities.DEFAULT_CONSUMER_NAME : element.consumerClass;
		if ( psType == PubSubType.PUBLISHER) {
			name = element == null ? evt_PlatformEvtUtilities.DEFAULT_PUBLISHER_NAME : element.publisherClass;
		}

		return name;
	} // end of getEventHandlerValue
	/**
	 * @description is the event active (ONLY checking the first one!!)
	 *
	 * @param element data from the custom metadata
	 * @return is the event active
	 */
	@TestVisible
	static Boolean isEventActive(List<evt_PlatformEvtMdtDataModel.PEDataModelInformation> elements) {
		Boolean isActive = true;
		evt_PlatformEvtMdtDataModel.PEDataModelInformation element = elements != null && elements.size() > 0 ? elements[0] : null;

		if ( element != null) {
			isActive = element.isActive;
		}

		return isActive;
	} // end of isEventActive

} // end of evt_PlatformEvtBuilder