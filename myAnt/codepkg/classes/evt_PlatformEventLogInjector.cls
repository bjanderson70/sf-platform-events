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
 * @description Platform Event Data Access Object to work on (enque to process asynchromosuly)
 * @group Logs the PE information
 */
public class evt_PlatformEventLogInjector {

	/////////////////////////////////////////////////////////////////////////
	// Data Members
	/////////////////////////////////////////////////////////////////////////
	public class evt_PlatformEventLogInjectorException extends Exception {}

	// data access object of event information
	@TestVisible
	private List<evt_PlatformEventDAOLog> m_entries = new List<evt_PlatformEventDAOLog>();

	/////////////////////////////////////////////////////////////////////////
	// Ctors
	/////////////////////////////////////////////////////////////////////////

	/**
	 * @description ctor, injecting one element
	 *
	 */
	public evt_PlatformEventLogInjector(evt_PlatformEventDAOLog entry) {
		if (entry != null ) {
			this.m_entries.add(entry);
		}
	} // end of ctor
	/**
	 * @description , injecting list of elements
	 *
	 */
	public evt_PlatformEventLogInjector(List<evt_PlatformEventDAOLog> entries) {
		if (entries != null ) {
			this.m_entries.addAll(entries);
		}
	} // end of ctor


	/////////////////////////////////////////////////////////////////////////
	// Public Methods
	/////////////////////////////////////////////////////////////////////////

	/**
	 * @description store data
	 * @return boolean true, if no errors
	 */
	public boolean store() {
		return this.processAction(false);
	}// end of store
	/**
	 * @description remove data
	 * @return boolean true, if no errors
	 */
	public boolean remove() {
		return this.processAction(true);
	} // end of remove


	/////////////////////////////////////////////////////////////////////////
	// Private Methods
	/////////////////////////////////////////////////////////////////////////
	/**
	 * @description process the the store or removal of information from the Big Object
	 *
	 * @param isRemovingData rue, if removing data from Big Object
	 * @return true on success enqueing of action
	 */
	@TestVisible
	private boolean processAction(boolean isRemovingData) {
		boolean results = true;
		try {
			evt_PlatformEventLogDataQueueHandler handler = this.getHandler(isRemovingData);

			// evt_PlatformEventLogDataQueueHandler is an asynchronous queuable Apex class
			if ( handler != null ) {
				evt_PlatformEventLogger.myInstance().log('+++ evt_PlatformEventLogDataQueueHandler.processAction :' + this.m_entries.size());
				System.enqueueJob(handler);
			}
		} catch (Exception excp) {
			evt_PlatformEventLogger.myInstance().log('+++ evt_PlatformEventLogInjector Exception: ' + excp.getMessage() + '\n=====' + excp.getStackTraceString() );
			throw new evt_PlatformEventLogInjectorException(excp.getMessage());

		}
		return results;
	} // end of processAction
	/**
	 * @description get the appropriate handler to add/remove data
	 *
	 * @param doRemove true if removing data, false otherwise
	 * @return Queue/Async Handler
	 */
	@TestVisible
	private evt_PlatformEventLogDataQueueHandler getHandler(boolean doRemove) {
		evt_PlatformEventLogDataQueueHandler handler = null;
		// any work?
		if ( this.m_entries.size() > 0 ) {
			handler = new evt_PlatformEventLogDataQueueHandler(this.m_entries, doRemove);
		}

		return handler;
	}// end of getHandler

} // end of evt_PlatformEventLogInjector