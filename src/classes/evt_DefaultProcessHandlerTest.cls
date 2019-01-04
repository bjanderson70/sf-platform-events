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
 * @description defines the default process handlers ( log, success, error, alert) tests
 * @group Test Layer
 */
@isTest
private class evt_DefaultProcessHandlerTest {
	@isTest
	static void testCtor() {
		// assig/act
		evt_DefaultProcessHandler ctor = new evt_DefaultProcessHandler();
		// assert
		System.assertEquals(true, ctor != null);
		System.assertEquals(true, ctor.handlerName() == evt_DefaultProcessHandler.DEFAULT_NAME);
	}
	@isTest
	static void testCtorWithNullParameter() {
		// assign /act
		evt_DefaultProcessHandler ctor = new evt_DefaultProcessHandler(null);
		// assert
		System.assertEquals(true, ctor != null);
		System.assertEquals(true, ctor.handlerName() == evt_DefaultProcessHandler.DEFAULT_NAME);
	}
	@isTest
	static void testhandlerName() {
		// assign
		final String newName = 'new-name';
		evt_DefaultProcessHandler ctor = new evt_DefaultProcessHandler();
		// assert
		System.assertEquals(true, ctor != null);
		System.assertEquals(true, ctor.handlerName() == evt_DefaultProcessHandler.DEFAULT_NAME);
		// act
		ctor.handlerName(newName);
		// assert
		System.assertEquals(true, ctor.handlerName() == newName);
	}
	@isTest
	static void testprocess() {
		// assign
		Boolean result = false;
		evt_DefaultProcessHandler ctor = new evt_DefaultProcessHandler();
		try {
			// act
			ctor.process(null, null);
		} catch (evt_PlatformEventException excp) {
			result = true;
		}
		// assert
		System.assertEquals(true, result);
	}
	@isTest
	static void testprocessWithOneNullParamter() {
		// assign
		Boolean result = true;
		String returnData = null;
		List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC> data = new List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC>();
		evt_DefaultProcessHandler ctor = new evt_DefaultProcessHandler();

		try {
			// act
			returnData = (String)ctor.process(data, null);
		} catch (evt_PlatformEventException excp) {
			result = false;
		}
		// assert
		System.assertEquals(true, result);
		System.assertEquals(true, returnData.contains('evt_DefaultProcessHandler.childProcess'));
	}
	@isTest
	static void testchildProcessNullParameter() {
		// assign
		Boolean result = false;
		String data = null;
		evt_DefaultProcessHandler ctor = new evt_DefaultProcessHandler();
		try {
			// act
			data = (String)ctor.childProcess(null, null);
		} catch (Exception excp) {
			result = true;
		}
		// assert
		System.assertEquals(true, data == null);
		System.assertEquals(true, result);
		System.assertEquals(true, ctor.handlerException() != null);

	}
	@isTest
	static void testhandlerException() {
		// assig/act
		evt_DefaultProcessHandler ctor = new evt_DefaultProcessHandler();
		// assert
		System.assertEquals(true, ctor.handlerException() == null);
	}// end of testhandlerException

	@isTest
	static void testtoString() {
		// assig/act
		evt_DefaultProcessHandler ctor = new evt_DefaultProcessHandler();
		// assert
		System.assertEquals(true, ctor.toString() != null);
	}// end of testtoString

	@isTest
	static void testmakeResultsFromList() {
		// assign
		List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC> data = new List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC> {
			new evt_DefaultPlatformEvent.PlatformEvtResultPOAC('theName', 'theDatum', null, 10)
			, new evt_DefaultPlatformEvent.PlatformEvtResultPOAC('theName2', 'theDatum2', null, 20)
			, new evt_DefaultPlatformEvent.PlatformEvtResultPOAC(new evt_DefaultPlatformEvent.ErrorResultPOAC('error'))
		};
		// act
		String badData = evt_DefaultProcessHandler.makeResultsFromList(null);
		String withData = evt_DefaultProcessHandler.makeResultsFromList(data);
		// assert
		system.assertEquals(true, badData.contains('****'));
		system.assertEquals(true, withData.contains('theName2'));
		system.assertEquals(true, withData.contains('error'));

	}
}