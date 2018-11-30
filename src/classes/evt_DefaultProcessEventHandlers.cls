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
 * @description define the default implementation of the core platform event event handlers container
 * @group Common  Layer
 */
public without sharing class evt_DefaultProcessEventHandlers implements evt_IProcessEventHandlers {

	/////////////////////////////////////////////////////////////////////////////////////////
	// Data Members
	/////////////////////////////////////////////////////////////////////////////////////////

	// use to index into the user-defined name
	enum Handler_Type {
		LOG,
		ERROR,
		SUCCESS,
		ALERT,
		STORE
	}
	// default handlers and names
	@TestVisible
	static Map<String, evt_IProcessEventHandler> m_DefaultHandlers = new  Map<String, evt_IProcessEventHandler> {
		evt_DefaultProcessHandler.DEFAULT_LOG_NAME => new evt_DefaultProcessHandler(evt_DefaultProcessHandler.DEFAULT_LOG_NAME)
		, evt_DefaultProcessHandler.DEFAULT_ERROR_NAME => new evt_DefaultProcessHandler(evt_DefaultProcessHandler.DEFAULT_ERROR_NAME)
		, evt_DefaultProcessHandler.DEFAULT_SUCCESS_NAME => new evt_DefaultProcessHandler(evt_DefaultProcessHandler.DEFAULT_SUCCESS_NAME)
		, evt_DefaultProcessHandler.DEFAULT_ALERT_NAME => new evt_DefaultProcessHandler(evt_DefaultProcessHandler.DEFAULT_ALERT_NAME)
		, evt_DefaultProcessHandler.DEFAULT_STORE_NAME => new evt_DefaultProcessHandler(evt_DefaultProcessHandler.DEFAULT_STORE_NAME)
	};
	// user-defined handlers ( initially, same as default)
	@TestVisible
	static Map<String, evt_IProcessEventHandler> m_DefineHandlers = new  Map<String, evt_IProcessEventHandler>(m_DefaultHandlers);
	// user reference type to find user-defined name
	static Map<Handler_Type, String> m_referenceByType = new Map<Handler_Type, String>();
	/////////////////////////////////////////////////////////////////////////////////////////
	// Ctors
	/////////////////////////////////////////////////////////////////////////////////////////

	/**
	 * @brief ctor
	 * @description ctor
	 *
	 */
	public evt_DefaultProcessEventHandlers() {
		this(null, null, null, null, null);
	} // end of ctor
	/**
	 * @description ctor (chaining to account for various handlers)
	 *
	 */
	public evt_DefaultProcessEventHandlers(evt_IProcessEventHandler theLogHandler) {
		this(theLogHandler, null, null, null, null);
	} // end of ctor

	public evt_DefaultProcessEventHandlers(evt_IProcessEventHandler theLogHandler
	                                       , evt_IProcessEventHandler theErrorHandler) {
		this(theLogHandler, theErrorHandler, null, null, null);
	} // end of ctor

	public evt_DefaultProcessEventHandlers(evt_IProcessEventHandler theLogHandler
	                                       , evt_IProcessEventHandler theErrorHandler
	                                       , evt_IProcessEventHandler theSuccessHandler) {
		this(theLogHandler, theErrorHandler, theSuccessHandler, null, null);
	} // end of ctor

	public evt_DefaultProcessEventHandlers(evt_IProcessEventHandler theLogHandler
	                                       , evt_IProcessEventHandler theErrorHandler
	                                       , evt_IProcessEventHandler theSuccessHandler
	                                       , evt_IProcessEventHandler theAlertHandler ) {
		this(theLogHandler, theErrorHandler, theSuccessHandler, theAlertHandler, null);
	}// end of ctor

	public evt_DefaultProcessEventHandlers(evt_IProcessEventHandler theLogHandler
	                                       , evt_IProcessEventHandler theErrorHandler
	                                       , evt_IProcessEventHandler theSuccessHandler
	                                       , evt_IProcessEventHandler theAlertHandler
	                                       , evt_IProcessEventHandler theStoreHandler ) {
		evt_IProcessEventHandler myLogHandler = theLogHandler == null ? m_DefaultHandlers.get(evt_DefaultProcessHandler.DEFAULT_LOG_NAME) : theLogHandler;
		evt_IProcessEventHandler myErrorHandler = theErrorHandler == null ? m_DefaultHandlers.get(evt_DefaultProcessHandler.DEFAULT_ERROR_NAME) : theErrorHandler;
		evt_IProcessEventHandler mySuccessHandler = theSuccessHandler == null ? m_DefaultHandlers.get( evt_DefaultProcessHandler.DEFAULT_SUCCESS_NAME ) : theSuccessHandler;
		evt_IProcessEventHandler myAlertHandler = theAlertHandler == null ? m_DefaultHandlers.get(evt_DefaultProcessHandler.DEFAULT_ALERT_NAME) : theAlertHandler;
		evt_IProcessEventHandler myStoreHandler = theStoreHandler == null ? m_DefaultHandlers.get( evt_DefaultProcessHandler.DEFAULT_STORE_NAME ) : theStoreHandler;

		m_DefineHandlers.put(myAlertHandler.handlerName().toLowerCase(), myAlertHandler);
		m_DefineHandlers.put(mySuccessHandler.handlerName().toLowerCase(), mySuccessHandler);
		m_DefineHandlers.put(myErrorHandler.handlerName().toLowerCase(), myErrorHandler);
		m_DefineHandlers.put(myLogHandler.handlerName().toLowerCase(), myLogHandler);
		m_DefineHandlers.put(myStoreHandler.handlerName().toLowerCase(), myStoreHandler);

		m_referenceByType.put(Handler_Type.LOG, myLogHandler.handlerName().toLowerCase());
		m_referenceByType.put(Handler_Type.STORE, myStoreHandler.handlerName().toLowerCase());
		m_referenceByType.put(Handler_Type.ERROR, myErrorHandler.handlerName().toLowerCase());
		m_referenceByType.put(Handler_Type.SUCCESS, mySuccessHandler.handlerName().toLowerCase());
		m_referenceByType.put(Handler_Type.ALERT, myAlertHandler.handlerName().toLowerCase());

	} // end of ctor

	/////////////////////////////////////////////////////////////////////////////////////////
	// Public Methods
	/////////////////////////////////////////////////////////////////////////////////////////

	// getters

	// log information on the event
	public evt_IProcessEventHandler logHandler() {
		return evt_DefaultProcessEventHandlers.m_DefineHandlers.get(m_referenceByType.get(Handler_Type.LOG));
	}
	// process errors
	public evt_IProcessEventHandler errorHandler() {
		return evt_DefaultProcessEventHandlers.m_DefineHandlers.get(m_referenceByType.get(Handler_Type.ERROR));
	}
	// process successes
	public evt_IProcessEventHandler successHandler() {
		return evt_DefaultProcessEventHandlers.m_DefineHandlers.get(m_referenceByType.get(Handler_Type.SUCCESS));
	}
	// process alerts/notifcations
	public evt_IProcessEventHandler alertHandler() {
		return evt_DefaultProcessEventHandlers.m_DefineHandlers.get(m_referenceByType.get(Handler_Type.ALERT));
	}
	// process store handler
	public evt_IProcessEventHandler storeHandler() {
		return evt_DefaultProcessEventHandlers.m_DefineHandlers.get(m_referenceByType.get(Handler_Type.STORE));
	}
	/**
	 * @description find the process event handler by name
	 *
	 * @param name name stored as (default names found here 'evt_DefaultProcessHandler' )
	 * @return evt_IProcessEventHandler, porcess event handler
	 */
	public static evt_IProcessEventHandler defaultHandlerByName(String name) {
		evt_IProcessEventHandler result = null;
		if ( !string.isBlank(name)) {
			String lcName = name.toLowerCase();
			evt_IProcessEventHandler current = null;
			
			for ( String item : evt_DefaultProcessEventHandlers.m_DefineHandlers.keyset() ) {
				current = evt_DefaultProcessEventHandlers.m_DefineHandlers.get(item);
				if (  current.handlerName() == lcName ) {
					result = current;
					break;
				}
			}
		}
		return result;
	} // end of defaultHandlerByName

} // end of evt_DefaultProcessEventHandlers