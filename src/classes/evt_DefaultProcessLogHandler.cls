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
 * @description This class is called when an event is needed to be logged.
 *
 * @group Common Layer
 */
public virtual without sharing class evt_DefaultProcessLogHandler  extends evt_DefaultProcessHandler {


	////////////////////////////////////////////////////////////////////////
	// Data Members
	/////////////////////////////////////////////////////////////////////////

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
	/**
	* @description override to String to show contents
	* @return string of evt_DefaultProcessHandler contents
	*/
	public  override String toString() {

		return
		    super.toString() + '\n' +
		    'evt_DefaultProcessLogHandler\n' +
		    '{' +
		    '\n' +
		    '}';
	} //  end of toString
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

		try {
			if ( parameter == null ) {
				throw new NullPointerException();
			}
			List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC> data = (List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC> )parameter;

			String placeholder = '++++ MESSAGE ++++ [{0}] : evt_DefaultProcessStoreHandler.childProcess called\n {1}';
			String results = evt_DefaultProcessHandler.makeResultsFromList(data);
			List<String> fillers = new String[] { this.handlerName(),  results };
			result = String.format(placeholder, fillers);

			evt_PlatformEventLogger.myInstance().log(result);
			List<String> items = new List<String>();

			if ( data != null ) {
				integer size = data.size();
				for ( integer inx = 0; inx < size; ++inx ) {
					items.add(data[inx].toString());
				}
				result = String.join(items, '\n++++++++++++++++\n');
			}
			evt_PlatformEventLogger.myInstance().log(result);

		} catch (Exception excp) {
			result = excp.getMessage();
		}

		return result;
	} // end of childProcess

} // end of evt_DefaultProcessLogHandler