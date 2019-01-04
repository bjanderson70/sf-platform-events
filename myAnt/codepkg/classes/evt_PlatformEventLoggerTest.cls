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
 * @description Platform Event Logger Tester (Singleton for the public; not so for protected/children)
 * @group Test Layer
 */
@isTest
private  class evt_PlatformEventLoggerTest {
	@isTest
	static void testlog() {
		evt_PlatformEventLogger.myInstance().log('test me');
		System.assertEquals( true, evt_PlatformEventLogger.myInstance().inLog('test me'));
		evt_PlatformEventLogger.m_logInformation.clear();
		evt_PlatformEventLogger.myInstance().log((String)null);
		System.assertEquals( evt_PlatformEventLogger.m_logInformation.size(), 1);
	}
	@isTest
	static void testlogWithException() {
		evt_PlatformEventException excp = new evt_PlatformEventException('test me');

		evt_PlatformEventLogger.myInstance().log(excp);
		System.assertEquals( true, evt_PlatformEventLogger.myInstance().inLog('test me'));
		evt_PlatformEventLogger.m_logInformation.clear();
		evt_PlatformEventLogger.myInstance().log((Exception)null);
		System.assertEquals(true, evt_PlatformEventLogger.m_logInformation.size() == 0);
	} // end of testlogWithException

	@isTest
	static void testinLog() {
		evt_PlatformEventLogger.myInstance().log('test me');
		System.assertEquals( true, evt_PlatformEventLogger.myInstance().inLog('test me'));
		evt_PlatformEventLogger.m_logInformation.clear();
		evt_PlatformEventLogger.myInstance().log((String)null);
		System.assertEquals( evt_PlatformEventLogger.myInstance().inLog(null), false);
	}
	@isTest
	static void testlogAsPlatformEvent() {
		//assign/act
		evt_PlatformEventLogger.myInstance().logAsPlatformEvent(LoggingLevel.DEBUG, 'test');
		//assert
		System.assertEquals( true, evt_PlatformEventLogger.myInstance().getInLog().contains('test'));
	}
} // end of evt_PlatformEventLoggerTest