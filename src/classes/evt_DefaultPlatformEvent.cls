/**
 * Copyright (c) 2016-2018, Bill Anderson.  All rights reserved.
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
 * @description defines the default platform event process. This class SHOULD NOT be used to process
 * platform events (pub/sub) bec/ it defines the shell/pattern to use. The intent was to have subclasses
 * to do the following :
 *    1) Override the 'process' method
 *    2) Use a builder pattern to ensure the process-handlers are defined
 *
 * NOTE: 'evt_DefaultPEPublisher' and 'evt_DefaultPEConsumer' define the process but DO NOT define the handlers!
 *
 * Ideally, define custom metadata to seed the correct object/class (done via a builder). This way
 * one can vary the behavior of the platform events
 *
 * @group Common Layer
 */
public virtual without sharing class evt_DefaultPlatformEvent implements evt_IEventHandler {

	/////////////////////////////////////////////////////////////////////////
	// Data Members
	/////////////////////////////////////////////////////////////////////////

	/**
	 * @description Error information for processed events
	 */
	public class ErrorResultPOAC {
		/////////////////////////////////////////////////////////////
		// DATA MEMBERS
		/////////////////////////////////////////////////////////////
		public string Message;
		public System.StatusCode Code = StatusCode.INVALID_STATUS;
		/////////////////////////////////////////////////////////////
		// Ctors
		/////////////////////////////////////////////////////////////
		public ErrorResultPOAC(System.StatusCode theCode, String theMessage) {
			this.Message = theMessage;
			this.Code = theCode;
		}
		public ErrorResultPOAC(String theMessage) {
			this.Message = theMessage;
		}
	} // end of ErrorResultPOAO

	/**
	 * @description this Plain Old Apex Class (POAC) is used by the platform events for data transfer
	 *
	 */
	public class PlatformEvtResultPOAC {
		/////////////////////////////////////////////////////////////
		// DATA MEMBERS
		/////////////////////////////////////////////////////////////

		public string Datum = '';
		public string Name = '';
		public Object Misc = null;
		public long TheTime = 0;
		public List<ErrorResultPOAC> error = null;

		/////////////////////////////////////////////////////////////
		// Ctors
		/////////////////////////////////////////////////////////////
		public PlatformEvtResultPOAC(ErrorResultPOAC theError) {
			if ( error == null) {
				error = new List<ErrorResultPOAC> ();
			}
			error.add(theError);
		}
		public PlatformEvtResultPOAC(string theName) {
			this(theName, null, null, System.currentTimeMillis());

		}
		public PlatformEvtResultPOAC(string theName, string theDatum) {
			this(theName, theDatum, null, System.currentTimeMillis());

		}
		public PlatformEvtResultPOAC(string theName, string theDatum, Object miscellaneousData) {
			this(theName, theDatum, miscellaneousData, System.currentTimeMillis());
		}
		public PlatformEvtResultPOAC(string theName, string theDatum, Object miscellaneousData, long cpuTime) {
			this.Datum = theDatum;
			this.Name = theName;
			this.Misc = miscellaneousData;
			this.TheTime = cpuTime;
		}
		/////////////////////////////////////////////////////////////
		// PUBLIC MEMBERS
		/////////////////////////////////////////////////////////////
		public override String toString() {
			List<String> data = new List<String> {
				'Name=' + this.Name
				, '\nDatum=' + this.Datum
				, '\nMisc=' + string.valueOf(this.Misc)
				, '\nTheTime=' + this.TheTime + ' (ms)'

			};
			if ( this.TheTime != 0 ) {
				data.add('\nConverted Time=' + DateTime.newInstance(this.TheTime).format());
			}
			if ( this.error != null ) {
				for (ErrorResultPOAC item : this.error) {
					data.add('\n-------------------------');
					data.add('\nerror.Message=' + item.Message);
					data.add('\nerror.Code=' + item.Code);
				}
			}
			return String.join(data, '\n');
		} // end of toString
	} // end of PlatformEvtResultPOAC
	// The event Name
	@TestVisible
	String m_eventName = null;
	// the Exception
	@TestVisible
	Exception m_exception = null;
	// use the attributes to determine logging
	@TestVisible
	Boolean m_canLogSuccess = false,
	        m_canLogError = false,
	        m_canLog = false,
	        m_willInstrument = false,
	        m_retry = false,
	        m_serializeEvent = false,
	        m_isActive = true,
	        m_allowRetryAfterException = true;
	/////////////////////////////////////////////////////////////////////////
	// Ctors
	/////////////////////////////////////////////////////////////////////////
	/**
	 * @description default ctor
	 *
	 */
	public evt_DefaultPlatformEvent() {
		this(null, true, true);
	}// end of ctor

	/**
	 * @description ctor with event name
	 *
	 * @param theEventName the event name
	 */
	public evt_DefaultPlatformEvent(String theEventName) {
		this(theEventName, true, true);
	}// end of ctor
	/**
	 * @description ctor with event name
	 *
	 * @param theEventName the event name
	 * @param serializeTheEvent the data should be serialize
	 */
	public evt_DefaultPlatformEvent(String theEventName, Boolean serializeTheEvent) {
		this(theEventName, serializeTheEvent, true);
	}// end of ctor
	/**
	 * @description ctor with event name
	 *
	 * @param theEventName the event name
	 * @param serializeTheEvent the data should be serialize
	 * @param isActive is the event active
	 */
	public evt_DefaultPlatformEvent(String theEventName, Boolean serializeTheEvent, Boolean isActive) {
		this.eventName = theEventName;
		this.serializeEvent = serializeTheEvent;
		this.isEventActive = isActive;
	}// end of ctor
	/////////////////////////////////////////////////////////////////////////
	// Public Methods ( as define in the contract)
	/////////////////////////////////////////////////////////////////////////

	/**
	 * @description is the event active
	 * @return true, if active
	 */
	public Boolean handlerIsActive() {
		return this.isEventActive;
	}
	/**
	 * @description  the event name, ('my_event__e')
	 * @return name of the event
	 */
	public String handlerEventName() {
		return this.eventName;
	}// end of handlerEventName
	/**
	 * @description allow a setter from the interface on the event namre
	 *
	 * @param theEventName string name
	 */
	public void handlerEventName(String theEventName) {
		this.eventName = theEventName;
	}// end of handlerEventName
	/**
	 * @description any exception which may have occurred
	 * @details [long description]
	 * @return  Exception
	 */
	public Exception handlerException() {
		return this.theException;
	}// end of handlerException
	/**
	 * @description retry required from the child. Normally, the consumer, processing an event via a trigger handler,
	 * indicates (via boolean) whether a retry is required within the trigger.
	 *
	 * Note : https://developer.salesforce.com/docs/atlas.en-us.platform_events.meta/platform_events/platform_events_subscribe_apex_refire.htm
	 * @return  Boolean
	 */
	public Boolean handlerRequiredRetry() {
		this.retryTriggerIfNecessary();
		return this.retryRequired;
	}// end of handlerRequiredRetry
	/**
	 * @description should the data be serialize for saving
	 *
	 * @return  Boolean
	 */
	public Boolean handlerToSerialize() {
		return this.serializeEvent;
	} // end of handlerToSerialize
	/**
	 * @description set the serialization of the event data
	 *
	 * @param doSerialize boolean
	 */
	public void handlerToSerialize(Boolean doSerialize) {
		this.serializeEvent = doSerialize;
	} // end of handlerToSerialize

	/////////////////////////////////////////////////////////////////////////
	// Public Properties
	/////////////////////////////////////////////////////////////////////////


	/**
	* Is the event Active
	*/
	public Boolean isEventActive {
		get { return this.m_isActive;}
		set { this.m_isActive = value;}
	} // end of isEventActive
	/**
	* Serialize the event(s)
	*/
	public Boolean serializeEvent {
		get { return this.m_serializeEvent;}
		set { this.m_serializeEvent = value;}
	} // end of serializeEvent
	/**
	* Allow consumer to retry event after retryexception
	*/
	public Boolean allowRetryAfterException {
		get { return this.m_allowRetryAfterException;}
		set { this.m_allowRetryAfterException = value;}
	} // end of allowRetryAfterException
	/**
	* Event name
	*/
	public String eventName {
		get { return this.m_eventName;}
		set { this.m_eventName = value;}
	} // end of eventName

	/**
	* Exception
	*/
	public Exception theException {
		get { return this.m_exception;}
		set { this.m_exception = value;}
	} // end of theException

	/////////////////////////////////////////////////////////////////////////
	// Protected Properties
	/////////////////////////////////////////////////////////////////////////

	/**
	* Retry Required
	*/
	@TestVisible
	protected Boolean retryRequired {
		get { return this.m_retry;}
		set { this.m_retry = value;}
	} // end of retryRequired

	@TestVisible
	protected Boolean canLogSuccess {
		get { return this.m_canLogSuccess;}
		set { this.m_canLogSuccess = value;}
	} // end of canLogSuccess
	@TestVisible
	protected Boolean canLog {
		get { return this.m_canLog;}
		set { this.m_canLog = value;}
	} // end of canLog
	@TestVisible
	protected Boolean canLogError {
		get { return this.m_canLogError;}
		set { this.m_canLogError = value;}
	} // end of canLogError

	@TestVisible
	protected Boolean willInstrument {
		get { return this.m_willInstrument;}
		set { this.m_willInstrument = value;}
	} // end of willInstrument
	/////////////////////////////////////////////////////////////////////////
	// Public Methods
	/////////////////////////////////////////////////////////////////////////

	/**
	 * @description process the publish or subscription/consumer. Expected 'childProcess' to be overwritten
	 *
	 * @param parameter the events
	 * @param handlers the handlers (log, error, success, alert)
	 * @param attributes platform event attributes
	 * @return true, if successful
	 */
	public boolean process(List<SObject> parameter, evt_IProcessEventHandlers handlers, evt_PlatformEventAttrs attributes) {

		if ( parameter == null
		        ||  parameter.size() == 0
		        || handlers == null
		        || attributes == null) {
			this.theException = new evt_PlatformEventException('evt_DefaultPlatformEvent.process requires valid data for all parameters [List<SObject>,evt_IProcessEventHandlers,evt_PlatformEventAttrs]');
			throw this.theException;
		}

		String parameterEventName =  evt_PlatformEvtUtilities.getSobjectName(parameter);
		Boolean childStatus = false,
		        isEventBlank = String.isBlank(this.eventName),
		        isParamEventName = String.isBlank(parameterEventName),
		        processResult = true;

		evt_PlatformEventAttrs.EventLogging logStatus = attributes.loggingStatus();

		this.willInstrument = attributes.instrumentation();
		this.allowRetryAfterException = attributes.allowRetryAfterException();

		// NOTE, the user may change the event serialization via attributes!!
		this.serializeEvent = attributes.serializeData();
		this.canLogSuccess = logStatus == evt_PlatformEventAttrs.EventLogging.ON_SUCCESS
		                     || logStatus == evt_PlatformEventAttrs.EventLogging.ALL;
		this.canLogError = logStatus == evt_PlatformEventAttrs.EventLogging.ON_ERROR
		                   || logStatus == evt_PlatformEventAttrs.EventLogging.ALL;
		this.canLog = logStatus == evt_PlatformEventAttrs.EventLogging.ON_LOG
		              || logStatus == evt_PlatformEventAttrs.EventLogging.ALL;

		// ensure we have an event name (from one aspect)
		if ( isEventBlank &&  !isParamEventName ) {
			this.eventName = parameterEventName;
		}

		// check event name
		if (  isEventBlank == false
		        &&  isParamEventName == false
		        && !this.eventName.equalsIgnoreCase(parameterEventName))  {
			this.theException = new evt_PlatformEventException('evt_DefaultPlatformEvent.process: Exception, event Name (' + this.eventName + ') is not the same as the event parameter passed in (' + parameterEventName + ')');
			throw this.theException;
		}
		// is the event active, then call the child process
		if ( this.isEventActive ) {
			processResult = this.childProcess(parameter, handlers, attributes);
		}
		return processResult;

	} // end of process


	/////////////////////////////////////////////////////////////////////////
	// Protected Methods
	/////////////////////////////////////////////////////////////////////////
	/**
	 * @description Normally called within a trigger handler, force a trigger handler to retry.
	 */
	@TestVisible
	protected virtual void retryTriggerIfNecessary() {
		if ( this.retryRequired && this.allowRetryAfterException) {
			throw new EventBus.RetryableException('Condition is not met, so retrying the trigger again.');
		}
	} // end of retryTriggerIfNecessary
	/**
	 * @description process the publish or subscription/consumer. Expected to be OVERRIDDEN!!
	 *
	 * @param parameter the events
	 * @param handlers the handlers (log, error, success, alert)
	 * @param attributes platform event attributes
	 * @return true, if successful
	 */
	@TestVisible
	protected virtual boolean childProcess(List<SObject> parameter, evt_IProcessEventHandlers handlers, evt_PlatformEventAttrs attributes) {
		return true;

	} // end of process
	/**
	 * @description invoke success,  can be overridden
	 *
	 * @param handler holds our process handlers
	 * @param data data to process, 'List<PlatformEvtResultPOAC>'
	 * @param attributes platform events attributes
	 */
	@TestVisible
	protected virtual boolean logSuccess (evt_IProcessEventHandlers handler,  List<PlatformEvtResultPOAC> data, evt_PlatformEventAttrs attributes ) {
		if ( handler != null && handler.successHandler() != null ) {
			return this.callHandler(handler.successHandler(), data, attributes);
		}
		return false;
	} // end of logSuccess
	/**
	 * @description invoke error handler, can be overridden
	 *
	 * @param handler holds our process handlers
	 * @param data data to process, 'List<PlatformEvtResultPOAC>'
	 * @param attributes platform events attributes
	 */
	@TestVisible
	protected virtual boolean  errorHandler (evt_IProcessEventHandlers handler, List<PlatformEvtResultPOAC> data, evt_PlatformEventAttrs attributes ) {
		if ( handler != null && handler.errorHandler() != null ) {
			return this.callHandler(handler.errorHandler(), data, attributes);
		}
		return false;
	} // end of errorHandler
	/**
	* @description invoke log handler , can be overridden
	*
	* @param handler holds our process handlers
	* @param data data to process, 'List<PlatformEvtResultPOAC>'
	* @param attributes platform events attributes
	*/
	@TestVisible
	protected virtual boolean logHandler (evt_IProcessEventHandlers handler, List<PlatformEvtResultPOAC> data, evt_PlatformEventAttrs attributes ) {
		if ( handler != null && handler.logHandler() != null ) {
			return this.callHandler(handler.logHandler(), data, attributes);
		}
		return false;
	} // end of logHandler

	/**
	 * @description invoke alert/notifications , can be overridden
	 *
	 * @param handler holds our process handlers
	 * @param data data to process, 'List<PlatformEvtResultPOAC>'
	 * @param attributes platform events attributes
	 */
	@TestVisible
	protected virtual boolean alertHandler (evt_IProcessEventHandlers handler,  List<PlatformEvtResultPOAC> data, evt_PlatformEventAttrs attributes ) {
		if ( handler != null && handler.alertHandler() != null ) {
			return this.callHandler(handler.alertHandler(), data, attributes);
		}
		return false;
	} // end of alertHandler

	/**
	 * @description write alert messages
	 *
	 * @param canAdd can the alert
	 * @param data item in the list
	 * @param theLogData the log information
	 */
	@TestVisible
	protected void addInstrumentation(Boolean canAdd
	                                  , evt_DefaultPlatformEvent.PlatformEvtResultPOAC data
	                                  , List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC> theLogData
	                                 ) {

		if ( canAdd
		        && data != null
		        && theLogData != null) {
			theLogData.add(data);
		}
	} // end of addInstrumentation

	/**
	 * @description call the handler. Values are already check for validity, we also ensure no exception
	 * bubbles up -- the callee MUST HANDLE exceptions
	 *
	 * @param handler holds our process handlers
	 * @param data data to process, 'List<PlatformEvtResultPOAC>'
	 * @param attributes platform events attributes
	 */
	@TestVisible
	protected virtual  boolean callHandler (evt_IProcessEventHandler handler, List<PlatformEvtResultPOAC> data, evt_PlatformEventAttrs attributes ) {
		boolean result = true;
		try {
			handler.process(data, attributes);
		} catch (Exception excp) {
			result = false;
			// REPLACE as needed to log to custom object, etc.
			evt_PlatformEventLogger.myInstance().log('++++ EXCEPTION +++++ evt_DefaultPlatformEvent.callHandler : Child DID NOT handle the exception' + excp.getMessage());
		}
		return result;
	} // end of callHandler
	/**
	 * @description allow children to send data and send out alert
	 *
	 * @param handler holds our process handlers
	 * @param theList data to process, 'List<PlatformEvtResultPOAC>'
	 * @param data the data , PlatformEvtResultPOAC
	 * @param attributes platform events attributes
	 *
	 * @return status of result of alert
	 */
	@TestVisible
	protected virtual boolean alertAddAndSend(evt_IProcessEventHandlers handler, PlatformEvtResultPOAC data, List<PlatformEvtResultPOAC> theList, evt_PlatformEventAttrs attributes ) {
		// any work to perform
		if ( handler == null
		        || data == null
		        || theList == null) {
			return false;
		}
		// add data
		theList.add(data);
		// forward to alert handler
		return this.alertHandler(handler, theList, attributes);
	} // end of alertAddAndSend
	/**
	 * @description serialize the collection of events
	 *
	 * @param collectionOfEvents colleciton of SObjects (i.e. __e)
	 * @return JSON string of the event collection
	 */
	@TestVisible
	protected virtual String serializeEventData(List<PlatformEvtResultPOAC> theList, List<SObject> collectionOfEvents) {
		String result = '{}';

		// just in case the serialization throws an exception
		try {
			integer count = 1;
			//evt_PlatformEventLogger.myInstance().log('+++ In evt_DefaultPlatformEvent.serializeEventData :' + this.serializeEvent);
			// if the user wants to serialize
			if ( this.serializeEvent &&
			        collectionOfEvents != null &&
			        collectionOfEvents.size() > 0 ) {

				result = JSON.serialize(collectionOfEvents);
				count = collectionOfEvents.size();

				// storage available and valid event name
				if (  theList != null && !string.isBlank(this.eventName)) {
					// add data for auditing/logging
					theList.add(new PlatformEvtResultPOAC(this.eventName, result, (Object)count));
				
				}
			}
		} catch (Exception excp) {
			this.theException = excp;
		}
		return result;
	} // end of serializeEventData

} // end of evt_DefaultPlatformEvent