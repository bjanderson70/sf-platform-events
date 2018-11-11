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
 * @description defines a handler. This class is called when an event is logged. Assuming the
 * Platform Attribute is serialize (== true) the event that is sent/received, this class will extract
 * the serialize event and push to the asynchronous queue to store in a Big Object. This serves two 
 * thoughts:
 *      1) Bec/ it is asynchronous it will have its own DML
 *      2) This is stored in a Big Object for AMPLE storage 
 *
 * If you need to extract the data, use a local custom object to push data into nightly (batch).
 * 
 * @group Common Layer
 */
public virtual without sharing class evt_DefaultProcessLogHandler  extends evt_DefaultProcessHandler {


	////////////////////////////////////////////////////////////////////////
	// Data Members
	/////////////////////////////////////////////////////////////////////////
	public static final string EVENT_TYPE_TAG_s = '__e';

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
	public evt_DefaultProcessLogHandler() {
		super(evt_DefaultProcessHandler.DEFAULT_LOG_NAME);
	} // end of ctor

	/**
	 * @brief ctor
	 * @description ctor
	 *
	 */
	public evt_DefaultProcessLogHandler(string name) {
		super(name);
	} // end of ctor

	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// Protected Methods
	//
	/////////////////////////////////////////////////////////////////////////////////////////
	/**
	 * @description Override this method if needed
	 *
	 * @param parameter data to the log,error, success, alert, etc.
	 * @param attributes  platform attributes
	 *
	 * @return object information
	 */
	@TestVisible
	protected override Object childProcess(Object parameter, evt_PlatformEventAttrs attributes) {
		String result = '';
		//evt_PlatformEventLogger.myInstance().log('++++ In evt_DefaultProcessLogHandler.childProcess.');
		//evt_PlatformEventLogger.myInstance().log('        +++++ getDMLStatements     : ' + Limits.getDMLStatements() + '\n' +
		//                             '        +++++ getLimitAsyncCalls   : ' + Limits.getLimitAsyncCalls() + '\n' +
		//                             '        +++++ getLimitQueueableJobs: ' + Limits.getLimitQueueableJobs() + '\n' +
		//                             '        +++++ getCpuTime           : ' + Limits.getCpuTime() + '\n' +
		//                             '        +++++ getLimitCpuTime      : ' + Limits.getLimitCpuTime() + '\n' +
		//                             '        ++++++getLimitAsyncCalls   : ' + Limits.getLimitAsyncCalls() + '\n' +
		//                             '        +++++ getDMLRows           : ' + Limits.getDMLRows() + '\n');
		try {
			if ( parameter == null ) {
				throw new NullPointerException();
			}
			List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC> data = (List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC> )parameter;
			List<evt_PlatformEventDAOLog> dbData = evt_DefaultProcessLogHandler.getEventInformation(data);
			// get the injector to store the data
			evt_PlatformEventLogInjector injector = new evt_PlatformEventLogInjector(dbData);
			injector.store();
			result = string.valueOf(dbData);

		} catch (Exception excp) {
			result = excp.getMessage();
		}

		return result;
	} // end of childProcess
	/**
	 * @description get the event information
	 *
	 * @param data collection of various data information on the event
	 * @return String, serialized event
	 */
	@TestVisible
	static List<evt_PlatformEventDAOLog> getEventInformation(List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC> data) {
		List<evt_PlatformEventDAOLog> result = new List<evt_PlatformEventDAOLog>();
		// any data to process 
		if ( data != null) {

			for ( evt_DefaultPlatformEvent.PlatformEvtResultPOAC item : data) {
				// event, should only be one and ends in '__e'
				// Note, the 'Misc' contains the # of events that were sent
				if ( !string.isBlank(item.Name) &&
				        item.Name.endsWith(evt_DefaultProcessLogHandler.EVENT_TYPE_TAG_s) ) {
					result.add(new evt_PlatformEventDAOLog(item.Name, item.Datum, (integer)item.Misc));
				}

			}
		}
		return result;
	} // end of getEventInformation

} // end of evt_DefaultProcessLogHandler