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
 * @author Bill Anderson
 * @description Platform Event Logger (Singleton for the public; not so for protected/children)
 * @group Logging
 */
public virtual without sharing class evt_PlatformEventLogger {

	/////////////////////////////////////////////////////////////////////////
	// Data Members
	/////////////////////////////////////////////////////////////////////////
	@TestVisible
	static List<String> m_logInformation = new List<String>();
	@TestVisible
	static evt_PlatformEventLogger m_instance = new evt_PlatformEventLogger();


	/////////////////////////////////////////////////////////////////////////
	// Public Virtual Methods (for overriding)
	/////////////////////////////////////////////////////////////////////////

	/**
	 * @description log information (overridable)
	 *
	 * @param level Logging level
	 * @param message message to send out
	 */
	public virtual void log(LoggingLevel level, String message) {
		evt_PlatformEventLogger.myInstance().logToSystem(level, message);
	} // end of log
	/**
	 * @description format log information (overridable)
	 *
	 * @param level Logging level
	 * @param message message to send out
	 */
	public virtual String format(LoggingLevel level, String message) {
		return evt_PlatformEventLogger.formatForOutput(level, message);
	}
	/**
	 * @description log information
	 *
	 * @param message message to send out
	 */
	public virtual void log(String message) {
		evt_PlatformEventLogger.myInstance().log(LoggingLevel.INFO, message);
	} // end of log
	/**
	 * @description log exception
	 *
	 * @param message exception message to send out
	 */
	public virtual void log(Exception message) {
		if ( message != null ) {
			evt_PlatformEventLogger.myInstance().log(LoggingLevel.ERROR, message.getMessage());
		}
	} // end of log
	
	/**
	 * @description log information
	 *
	 * @param level Logging level
	 * @param message message to send out
	 */
	public virtual void logAsPlatformEvent(LoggingLevel level, String message) {
		String msg = evt_PlatformEventLogger.myInstance().format(level, message);

		if (  Test.isRunningTest() ) {
			evt_PlatformEventLogger.m_logInformation.add(msg);
		}
		System.debug(LoggingLevel.INFO, msg);
	} // end of logAsPlatformEvent

	
	
	/////////////////////////////////////////////////////////////////////////
	// Public Static Methods
	/////////////////////////////////////////////////////////////////////////

	public static evt_PlatformEventLogger myInstance() {
		return evt_PlatformEventLogger.m_instance;
	}


	/////////////////////////////////////////////////////////////////////////
	// Protected Ctors
	/////////////////////////////////////////////////////////////////////////
	/**
	* @description ctor  Allow children to redefine
	*
	*/
	protected evt_PlatformEventLogger() {

	} // end of ctor


	/////////////////////////////////////////////////////////////////////////
	// Private  Methods
	/////////////////////////////////////////////////////////////////////////

	/**
	 * @description Formats data for output
	 *
	 * @param level Logging level
	 * @param message message to send out
	 *
	 * @return String, formatted delimiter of '^'
	 */
	private static String formatForOutput(LoggingLevel level, String message) {
		String msg = string.isBlank(message) ? ' (null) ' : message,
		       myformat = '++++ PL-EVT OUT ++++ [{0}] -- {1} ';
		List<String> fillers = new String[] {level.name(), msg };
		return String.format(myformat, fillers);

	} // end of formatForOutput

	/**
	 * @description for searching in the collection for a message
	 *
	 * @param value string value
	 *
	 * @return true if value is in collection of log messages
	 */
	@TestVisible
	private  boolean inLog(string value) {
		if ( value != null && Test.isRunningTest() ) {
			return evt_PlatformEventLogger.myInstance().getInLog().contains(value);
		}
		return false;
	}
	/**
	 * @description log information
	 *
	 * @param level Logging level
	 * @param message message to send out
	 */
	@TestVisible
	private  void logToSystem(LoggingLevel level, String message) {
		String msg =  evt_PlatformEventLogger.myInstance().format(level, message);

		if (  Test.isRunningTest() ) {
			evt_PlatformEventLogger.m_logInformation.add(msg);
		}
		System.debug(msg);
	} // end of logToSystem
	/**
	 * @description getting the log container
	 *
	 * @return value string value
	 */
	@TestVisible
	private  String getInLog() {
		String data = '';
		if ( Test.isRunningTest() ) {
			data = String.join(evt_PlatformEventLogger.m_logInformation, '^');
		}
		return data;
	}

} // end of evt_PlatformEventLogger