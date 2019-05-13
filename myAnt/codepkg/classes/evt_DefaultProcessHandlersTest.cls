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
 * @group Test  Layer
 */
@isTest
private class evt_DefaultProcessHandlersTest {
	@isTest
	static void testCtorNoParameters() {
		// assign/act
		evt_DefaultProcessEventHandlers ctor = new evt_DefaultProcessEventHandlers();
		// assert
		system.assertEquals(true, ctor != null);
		system.assertEquals(true, ctor.logHandler() instanceof evt_DefaultProcessHandler);
		system.assertEquals(true, ctor.errorHandler() instanceof evt_DefaultProcessHandler);
		system.assertEquals(true, ctor.successHandler() instanceof evt_DefaultProcessHandler);
		system.assertEquals(true, ctor.alertHandler() instanceof evt_DefaultProcessHandler);

	}
	@isTest
	static void testCtorOneParameters() {
		// assign/act
		evt_DefaultProcessEventHandlers ctor = new evt_DefaultProcessEventHandlers(new evt_DefaultProcessHandler());
		// assert
		system.assertEquals(true, ctor != null);
		system.assertEquals(true, ctor.logHandler() instanceof evt_DefaultProcessHandler);
		system.assertEquals(true, ctor.errorHandler() instanceof evt_DefaultProcessHandler);
		system.assertEquals(true, ctor.successHandler() instanceof evt_DefaultProcessHandler);
		system.assertEquals(true, ctor.alertHandler() instanceof evt_DefaultProcessHandler);
	}
	@isTest
	static void testCtorTwoParameters() {
		// assign/act
		evt_DefaultProcessEventHandlers ctor = new evt_DefaultProcessEventHandlers(new evt_DefaultProcessHandler(), new evt_DefaultProcessHandler());
		// assert
		system.assertEquals(true, ctor != null);
		system.assertEquals(true, ctor.logHandler() instanceof evt_DefaultProcessHandler);
		system.assertEquals(true, ctor.errorHandler() instanceof evt_DefaultProcessHandler);
		system.assertEquals(true, ctor.successHandler() instanceof evt_DefaultProcessHandler);
		system.assertEquals(true, ctor.alertHandler() instanceof evt_DefaultProcessHandler);
	}
	@isTest
	static void testCtorThreeParameters() {
		// assign/act
		evt_DefaultProcessEventHandlers ctor = new evt_DefaultProcessEventHandlers(new evt_DefaultProcessHandler()
		        , new evt_DefaultProcessHandler()
		        , new evt_DefaultProcessHandler());
		// assert
		system.assertEquals(true, ctor != null);
		system.assertEquals(true, ctor.logHandler() instanceof evt_DefaultProcessHandler);
		system.assertEquals(true, ctor.errorHandler() instanceof evt_DefaultProcessHandler);
		system.assertEquals(true, ctor.successHandler() instanceof evt_DefaultProcessHandler);
		system.assertEquals(true, ctor.alertHandler() instanceof evt_DefaultProcessHandler);
	}
	@isTest
	static void testCtorFourParameters() {
		// assign/act
		evt_DefaultProcessEventHandlers ctor = new evt_DefaultProcessEventHandlers(new evt_DefaultProcessHandler()
		        , new evt_DefaultProcessHandler()
		        , new evt_DefaultProcessHandler()
		        , new evt_DefaultProcessHandler());
		// asssert
		system.assertEquals(true, ctor != null);
		system.assertEquals(true, ctor.logHandler() instanceof evt_DefaultProcessHandler);
		system.assertEquals(true, ctor.errorHandler() instanceof evt_DefaultProcessHandler);
		system.assertEquals(true, ctor.successHandler() instanceof evt_DefaultProcessHandler);
		system.assertEquals(true, ctor.alertHandler() instanceof evt_DefaultProcessHandler);
	}
	@isTest
	static void testdefaultHandlerByName() {
		// assign/act
		evt_DefaultProcessEventHandlers hndlrs = new evt_DefaultProcessEventHandlers();
		evt_IProcessEventHandler handler = evt_DefaultProcessEventHandlers.defaultHandlerByName(evt_DefaultProcessHandler.DEFAULT_LOG_NAME);
		// assert
		system.assertEquals(true, handler instanceof evt_DefaultProcessHandler);
	}
	@isTest
	static void testdefaultHandlerByNameWithBadName() {
		// assign/act
		evt_IProcessEventHandler handler = evt_DefaultProcessEventHandlers.defaultHandlerByName('junk');
		// assert
		system.assertEquals(true, handler == null);
	}
}