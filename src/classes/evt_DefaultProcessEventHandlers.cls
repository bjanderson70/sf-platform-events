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

	public static final String LOG_HANDLER_s = 'loghandler';
	public static final String ERROR_HANDLER_s = 'errorhandler';
	public static final String SUCCESS_HANDLER_s = 'successhandler';
	public static final String ALERT_HANDLER_s = 'alerthandler';
	public static final String STORE_HANDLER_s = 'storehandler';

	@TestVisible
	static Map<String, evt_IProcessEventHandler> DefaultHandlers = new  Map<String, evt_IProcessEventHandler> {
		LOG_HANDLER_s => new evt_DefaultProcessHandler(evt_DefaultProcessHandler.DEFAULT_LOG_NAME)
		, ERROR_HANDLER_s => new evt_DefaultProcessHandler(evt_DefaultProcessHandler.DEFAULT_ERROR_NAME)
		, SUCCESS_HANDLER_s => new evt_DefaultProcessHandler(evt_DefaultProcessHandler.DEFAULT_SUCCESS_NAME)
		, ALERT_HANDLER_s => new evt_DefaultProcessHandler(evt_DefaultProcessHandler.DEFAULT_ALERT_NAME)
		, STORE_HANDLER_s => new evt_DefaultProcessHandler(evt_DefaultProcessHandler.DEFAULT_STORE_NAME)
	};

	// log information on the event
	@TestVisible
	evt_IProcessEventHandler m_logHandler;
	// process errors
	@TestVisible
	evt_IProcessEventHandler m_errorHandler;
	// process successes
	@TestVisible
	evt_IProcessEventHandler m_successHandler;
	// process alerts/notifcations
	@TestVisible
	evt_IProcessEventHandler m_alertHandler;
	// process storing of event(s)
	@TestVisible
	evt_IProcessEventHandler m_storeHandler;

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
		evt_IProcessEventHandler myLogHandler = theLogHandler == null ? DefaultHandlers.get(LOG_HANDLER_s) : theLogHandler;
		evt_IProcessEventHandler myErrorHandler = theErrorHandler == null ? DefaultHandlers.get(ERROR_HANDLER_s) : theErrorHandler;
		evt_IProcessEventHandler mySuccessHandler = theSuccessHandler == null ? DefaultHandlers.get(SUCCESS_HANDLER_s) : theSuccessHandler;
		evt_IProcessEventHandler myAlertHandler = theAlertHandler == null ? DefaultHandlers.get(ALERT_HANDLER_s) : theAlertHandler;
		evt_IProcessEventHandler myStoreHandler = theStoreHandler == null ? DefaultHandlers.get(STORE_HANDLER_s) : theStoreHandler;

		this.m_alertHandler = myAlertHandler;
		this.m_successHandler = mySuccessHandler;
		this.m_errorHandler = myErrorHandler;
		this.m_logHandler = myLogHandler;
		this.m_storeHandler = myStoreHandler;
	} // end of ctor

	// getters

	// log information on the event
	public evt_IProcessEventHandler logHandler() {
		return this.m_logHandler;
	}
	// process errors
	public evt_IProcessEventHandler errorHandler() {
		return this.m_errorHandler;
	}
	// process successes
	public evt_IProcessEventHandler successHandler() {
		return this.m_successHandler;
	}
	// process alerts/notifcations
	public evt_IProcessEventHandler alertHandler() {
		return this.m_alertHandler;
	}
	// process store handler
	public evt_IProcessEventHandler storeHandler() {
		return this.m_storeHandler;
	}

	public static evt_IProcessEventHandler defaultHandlerByName(String name) {
		evt_IProcessEventHandler result = null;
		if ( !string.isBlank(name)) {
			String lcName = name.toLowerCase();
			result = DefaultHandlers.get(lcName);
			if ( result != null ) {
				result.handlerName(lcName);
			}
		}
		return result;
	}
} // end of evt_DefaultProcessEventHandlers