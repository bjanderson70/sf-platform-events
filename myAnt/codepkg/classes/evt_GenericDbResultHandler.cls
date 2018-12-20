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
 * @description handle database results. Salesforce needs to refactor this result class to make more polymorphic!
 * @group Common Layer
 */
public without sharing class evt_GenericDbResultHandler {


	////////////////////////////////////////////////////////////////////////
	// Data Members
	/////////////////////////////////////////////////////////////////////////
	// result type
	//
	public enum ResultType {
		DELETE_RESULT
		, UPDATE_RESULT
		, UNDELETE_RESULT
		, INSERT_RESULT
	}
	@TestVisible
	List<Database.Error> m_errors = new List<Database.Error>();
	@TestVisible
	ResultType m_resultType;


	////////////////////////////////////////////////////////////////////////
	// Ctors
	/////////////////////////////////////////////////////////////////////////

	public evt_GenericDbResultHandler(List<Database.SaveResult> result) {
		this.theResultType = ResultType.INSERT_RESULT;
		integer size = result.size();
		for ( integer inx = 0; inx < size; inx++) {
			if ( result[inx].getErrors().size() > 0) {
				this.dbErrors.addAll(result[inx].getErrors());
			}
		}
	}// end of ctor

	public evt_GenericDbResultHandler(List<Database.UpsertResult> result) {
		this.theResultType = ResultType.UPDATE_RESULT;
		integer size = result.size();
		for ( integer inx = 0; inx < size; inx++) {
			if ( result[inx].getErrors().size() > 0) {
				this.dbErrors.addAll(result[inx].getErrors());
			}
		}
	}// end of ctor

	public evt_GenericDbResultHandler(List<Database.DeleteResult> result) {
		this.theResultType = ResultType.DELETE_RESULT;
		integer size = result.size();
		for ( integer inx = 0; inx < size; inx++) {
			if ( result[inx].getErrors().size() > 0 ) {
				this.dbErrors.addAll(result[inx].getErrors());
			}
		}
	}// end of ctor

	public evt_GenericDbResultHandler(List<Database.UndeleteResult> result) {
		this.theResultType = ResultType.UNDELETE_RESULT;
		integer size = result.size();
		for ( integer inx = 0; inx < size; inx++) {
			if ( result[inx].getErrors().size() > 0 ) {
				this.dbErrors.addAll(result[inx].getErrors());
			}
		}
	}// end of ctor

	////////////////////////////////////////////////////////////////////////
	// Public Methods
	/////////////////////////////////////////////////////////////////////////
	public List<Database.Error> dbErrors {
		get {return this.m_errors; }
		private set { this.m_errors = value;}
	}

	public ResultType theResultType {
		get { return this.m_resultType;}
		protected set { this.m_resultType = value;}
	}
	/**
	 * @description we have db errors
	 * @return true if errors
	 */
	public boolean hasErrors() {
		return this.dbErrors.size() != 0;
	}
	/**
	 * @description process errors
	 * @return List  of strings (errors)
	 */
	public List<String> processErrors() {
		List<String> loggedErrors = new List<String>();
		// Operation failed, so get all errors
		for (Database.Error err : this.dbErrors) {
			loggedErrors.add('The following error has occurred.');
			loggedErrors.add(err.getStatusCode() + ': ' + err.getMessage());
			loggedErrors.add('Fields that affected this error: ' + err.getFields());
		}
		if ( loggedErrors.size() > 0 ) {
			evt_PlatformEventLogger.myInstance().log(string.join(loggedErrors, '\n'));
		}
		return loggedErrors;
	} // end of processErrors

}