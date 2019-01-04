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
 * @description Platform Event queuable to insert or delete into/from BO
 * @group Data
 */
public class evt_PlatformEventLogDataQueueHandler implements Queueable {
	/////////////////////////////////////////////////////////////////////////
	// Data Members
	/////////////////////////////////////////////////////////////////////////

	@TestVisible
	private List<evt_Org_Events__b> m_entries;
	@TestVisible
	private Boolean m_removeAction = false;

	/////////////////////////////////////////////////////////////////////////
	// Ctors
	/////////////////////////////////////////////////////////////////////////

	/**
	* @description ctor to insert/or remove items from big object
	*
	* @param entries data entries
	*/
	public evt_PlatformEventLogDataQueueHandler(List<evt_PlatformEventDAOLog> entries) {

		this(entries, false);
	}
	/**
	* @description ctor to insert/or remove items from big object
	*
	* @param entries data entries
	*
	*/
	public evt_PlatformEventLogDataQueueHandler(List<evt_Org_Events__b> entries) {
		this(entries, false);

	}
	/**
	 * @description ctor to insert/or remove items from big object
	 *
	 * @param entries data entries
	 * @param remove true if to remove data; otherwise insert
	 *
	 */
	public evt_PlatformEventLogDataQueueHandler(List<evt_PlatformEventDAOLog> entries, boolean remove) {

		this.m_entries = evt_PlatformEventDAOLog.mapFrom(entries);
		this.m_removeAction = remove;
	}
	/**
	* @description ctor to insert/or remove items from big object
	*
	* @param entries data entries
	* @param remove tru if to remove data; otherwise insert
	*
	*/
	public evt_PlatformEventLogDataQueueHandler(List<evt_Org_Events__b> entries, boolean remove) {
		this.m_entries = entries;
		this.m_removeAction = remove;
	}
	/////////////////////////////////////////////////////////////////////////
	// Public Methods
	/////////////////////////////////////////////////////////////////////////

	/*
	* Here we insert the event data big object records,
	* or log an error if insertion fails.
	*/
	public void execute(QueueableContext context) {

		if ( this.m_entries == null || this.m_entries.size() == 0 ) {
			return;
		}
		this.process();

	} // end of execute
	/**
	 * @description process the db operation
	 */
	private void process() {
		try {
			evt_GenericDbResultHandler result = this.performDatabaseOperation();

			if ( result.hasErrors() ) {
				result.processErrors();
			}

		} catch (Exception excp) {
			// Exception occurred, output the exception message
			evt_PlatformEventLogger.myInstance().log(excp);
		}

	} // end of process
	/**
	 * @description perform the db op
	 * @return db handler evt_GenericDbResultHandler
	 */
	private evt_GenericDbResultHandler  performDatabaseOperation() {
		evt_GenericDbResultHandler result = null;

		if ( this.m_removeAction == false ) {
			// We have to use insertImmediate() to insert big object records.
			result = new evt_GenericDbResultHandler( Database.insertImmediate(this.m_entries));
		} else {
			result = new evt_GenericDbResultHandler(  Database.deleteImmediate(this.m_entries));
		}

		return result;
	} // end of performDatabaseOperation

} // end of evt_PlatformEventLogDataQueueHandler