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
 * @description defines the default publisher; YOU MUST inherit to change behavior
 * @group Common Layer
 */
public virtual without sharing class evt_DefaultPEPublisher extends evt_DefaultPlatformEvent {

	////////////////////////////////////////////////////////////////////////
	// Ctors
	/////////////////////////////////////////////////////////////////////////

	/**
	* @description default ctor
	*
	*/
	public evt_DefaultPEPublisher() {
		super(null);
	}
	/**
	* @description ctor with event name
	*
	* @param theEventName the event name
	*/
	public evt_DefaultPEPublisher(String theEventName) {
		super(theEventName);
	}
	/**
	* @description ctor with event name
	*
	* @param theEventName the event name
	* @param theSerializeEvent serialize the event
	*/
	public evt_DefaultPEPublisher(String theEventName, Boolean theSerializeEvent) {
		super(theEventName, theSerializeEvent);
	}

	////////////////////////////////////////////////////////////////////////
	// Public Methods
	/////////////////////////////////////////////////////////////////////////

	public virtual override String toString() {
		return super.toString() + '\n' +
		       '\tevt_DefaultPEPublisher\n' +
		       '\t{' + '\n' +
		       '\t}' + '\n'
		       ;
	}
	////////////////////////////////////////////////////////////////////////
	// Protected Methods
	/////////////////////////////////////////////////////////////////////////
	/**
	* @description publisher -- go through a stepwise process to alert, wrap, send and notify
	*
	* @param collectionOfEvents the events
	* @param handlers the handlers (log, error, success)
	* @param attributes platform event attributes
	* @return true, if successful
	*/
	protected override boolean childProcess(List<SObject> collectionOfEvents, evt_IProcessEventHandlers handlers, evt_PlatformEventAttrs attributes) {
		Boolean state = false;

		evt_PlatformEventAttrs.EventLogging logStatus = attributes.loggingStatus();

		// holds the errors
		List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC> errResult = new List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC>();
		// holds the data (i.e. json)
		List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC> theData = new List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC>();
		// holds the instrumentation data
		List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC> theLogData = new List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC>();
		// holds alert information
		List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC> theAlerts = new List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC>();
		// start message
		evt_DefaultPlatformEvent.PlatformEvtResultPOAC  alertMsg = new evt_DefaultPlatformEvent.PlatformEvtResultPOAC('Publisher: Start Time');

		super.addInstrumentation(super.willInstrument
		                         , alertMsg
		                         , theLogData);

		try {

			// Step 1: Notify
			//
			// add message and alert we have started
			super.alertAddAndSend(handlers, alertMsg, theAlerts, attributes);
			//
			// Step 2: Serialize Events
			//
			// add data for auditing/storage
			super.serializeEventData(theData, collectionOfEvents);
			//
			// Step 3: Check for Exceptions
			//
			// check for any exception
			if ( super.theException != null ) {
				errResult.add(new evt_DefaultPlatformEvent.PlatformEvtResultPOAC(new evt_DefaultPlatformEvent.ErrorResultPOAC(StatusCode.INVALID_STATUS, super.theException.getMessage())));
			} else {
				//
				// Step 4: Ready to Send , Instrumentation and Process
				state = this.readyToSend(collectionOfEvents
				                         , handlers
				                         , attributes
				                         , theData
				                         , errResult
				                         , theLogData
				                         , theAlerts);
			}
			//
			// Step 5: Complete Event Processing/Sending -- notify/alert
			//
			// add message and alert we are after publish
			super.alertAddAndSend(handlers
			                      , new evt_DefaultPlatformEvent.PlatformEvtResultPOAC('Publisher: After processResults')
			                      , theAlerts
			                      , attributes);

		} catch (Exception excp) {
			super.theException = excp;
			errResult.add(new evt_DefaultPlatformEvent.PlatformEvtResultPOAC(new evt_DefaultPlatformEvent.ErrorResultPOAC(StatusCode.INVALID_STATUS, excp.getMessage())));
			throw excp;

		} finally {
			//
			// Step 6: Final - Handle Notifications
			//

			// do not allow possible children to throw exceptions in our finally clause
			// instead, catch
			this.finallyProcess(collectionOfEvents
			                    , state
			                    , handlers
			                    , attributes
			                    , theData
			                    , errResult
			                    , theLogData
			                    , theAlerts);
		}

		return state;
	} // end of childProcess

	/**
	 * @description publish event -- it is a virtual in the event it needs to be overriden
	 *
	 * @param parameter event to publish
	 * @return List<Database.SaveResult>
	 */
	@TestVisible
	protected virtual List<Database.SaveResult> publish(List<SObject> parameter) {
		//
		// evt_PlatformEventLogger.myInstance().log('++++ Before Publish: \n' + evt_PlatformEvtUtilities.getDMLLimitsInStringForm());
		// Call method to publish events
		List<Database.SaveResult>  results = EventBus.publish(parameter);
		// evt_PlatformEventLogger.myInstance().log('++++ After Publish: \n' + evt_PlatformEvtUtilities.getDMLLimitsInStringForm());

		return results;
	} // end of publish

	/**
	 * @description process the results from the publish
	 *
	 * @param errResult logs any errors -- it is a virtual in the event it needs to be overriden
	 * @return void
	 */
	@TestVisible
	protected virtual integer processResults(List<Database.SaveResult> results, List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC> errResult) {
		integer count = results != null ? results.size() : 0;

		// Inspect publishing result for each event
		for (Database.SaveResult sr : results) {
			if (false == sr.isSuccess() ) {
				count--;
				if ( errResult != null ) {
					for (Database.Error err : sr.getErrors()) {
						errResult.add(new evt_DefaultPlatformEvent.PlatformEvtResultPOAC(new evt_DefaultPlatformEvent.ErrorResultPOAC(err.getStatusCode(), err.getMessage())));
					}
				}
			}
		}
		return count;
	} // end of processResults

	/**
	 * @description Allow the child to do anything after completion of the event publish process
	 *
	 * @param event the event
	 * @param state true if successful completion
	 * @param errResult the error log
	 * @param theData the event information (json)
	 * @param theLogData the log information
	 * @param attributes platform event attributes
	 * @return void
	 */
	@TestVisible
	protected virtual void handleCompletion(Object event
	                                        , Boolean state
	                                        , List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC> errResult
	                                        , List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC> theData
	                                        , List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC> theLogData
	                                        , evt_PlatformEventAttrs attributes) {
		//
		// NO-OP -- TO BE DEFINED BY CHILDREN  !!!
		//
	} // end of handleCompletion
	/**
		 *@description ready to send the information
		 *
		 * @param collectionOfEvents the event colection
		 * @param handlers the handlers (log, error, success)
		 * @param attributes platform event attributes
		 * @param errResult the error log
		 * @param theData the event information (json)
		 * @param theLogData the log information
		 * @param theAlerts the alert information
		 * @return true, if successful
		 */
	@TestVisible
	protected boolean readyToSend(List<SObject>  collectionOfEvents
	                              , evt_IProcessEventHandlers handlers
	                              , evt_PlatformEventAttrs attributes
	                              , List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC> theData
	                              , List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC> errResult
	                              , List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC> theLogData
	                              , List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC> theAlerts
	                             ) {
		integer count = 0, processed = 0;
		// add message and alert we are calling publish
		super.alertAddAndSend(handlers
		                      , new evt_DefaultPlatformEvent.PlatformEvtResultPOAC('Publisher: Before Publish')
		                      , theAlerts
		                      , attributes);
		// Call method to publish events
		List<Database.SaveResult> results = this.publish(collectionOfEvents);
		// record event publish time
		super.addInstrumentation(super.willInstrument,
		                         new evt_DefaultPlatformEvent.PlatformEvtResultPOAC('Publisher: Event Published')
		                         , theLogData);
		// add message and alert we are after publish
		super.alertAddAndSend(handlers
		                      , new evt_DefaultPlatformEvent.PlatformEvtResultPOAC('Publisher: After Publish')
		                      , theAlerts
		                      , attributes);
		// remember the number of results
		count = results.size();
		// Inspect publishing result for each event, return the decremented errors from the initial size
		processed = this.processResults(results, errResult);
		// record process of save result
		super.addInstrumentation(super.willInstrument,
		                         new evt_DefaultPlatformEvent.PlatformEvtResultPOAC('Publisher: SaveResult Processed')
		                         , theLogData);
		// check state based on return of results, if no match there was an error
		return count == processed ;
	} // end of readyToSend
	/**
		 *@description finallyProcess-- ensure all handlers are appropriately called and no exceptions
		 * are thrown from here. Capture exception, if any, into the memeber data
		 * @param collectionOfEvents the event colection
		 * @param state our current state
		 * @param handlers the handlers (log, error, success)
		 * @param attributes platform event attributes
		 * @param errResult the error log
		 * @param theData the event information (json)
		 * @param theLogData the log information
		 * @param theAlerts the alert information
		 * @return true, if successful
		 */
	@TestVisible
	protected void finallyProcess(List<SObject>  collectionOfEvents
	                              , Boolean state
	                              , evt_IProcessEventHandlers handlers
	                              , evt_PlatformEventAttrs attributes
	                              , List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC> theData
	                              , List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC> errResult
	                              , List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC> theLogData
	                              , List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC> theAlerts
	                             ) {
		// do not allow possible children to throw exceptions in our finally clause
		// instead, catch

		try {

			evt_PlatformEventLogger.myInstance().log('++++' + this.toString());

			// here we store event
			if ( theData.size() > 0 && super.isEventToBeStored ) {
				// store the event(s)
				super.storeHandler(handlers, theData, attributes);
			}
			// Here we log the successful state by calling it's handler
			if ( theData.size() > 0 && super.canLogSuccess && state == true ) {
				// Log the success marker, this will pass in the json data
				super.logSuccess(handlers, theData, attributes);
			}
			//
			// here we call the error handler, if any.
			//
			if ( errResult.size() > 0 && super.canLogError ) {
				super.errorHandler(handlers, errResult, attributes);
			}
			//
			// notify the handler of the instrumented data gathered
			//
			if ( theLogData.size() > 0 && super.canLog ) {
				super.addInstrumentation(super.willInstrument,
				                         new evt_DefaultPlatformEvent.PlatformEvtResultPOAC('Publisher : Process Done')
				                         , theLogData);
				// log the information on the event
				super.logHandler(handlers, theLogData, attributes);
			}
			//
			// add message and alert we are in finally
			//
			super.alertAddAndSend(handlers
			                      , new evt_DefaultPlatformEvent.PlatformEvtResultPOAC('Publisher: Finally State')
			                      , theAlerts
			                      , attributes);
			//
			// **** this is cleanup/completion to be defined by the CHILD method 'handleCompletion' ***
			// allow the children to do any other type of completion/ cleanup they want
			//
			this.handleCompletion(collectionOfEvents, state, errResult, theData, theLogData, attributes );
		} catch (Exception excp) {
			// if we are here, something occur with one of the handlers
			// save it for the callee
			super.theException = excp;
		}
	} // end of finallyProcess

} // end of evt_DefaultPEPublisher