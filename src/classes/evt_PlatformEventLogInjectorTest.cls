/**
 * Copyright (c) 2016-2019, Bill Anderson.  All rights reserved.
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
 * @description Test the Platform Event Data Access Object to work on (enque to process asynchronously)
 * @group Test Layer
 */
@isTest
private class evt_PlatformEventLogInjectorTest {
  @isTest
  static void testCtorevt_PlatformEventLogInjector() {
    // assign
    String name = 'logInfo';
    evt_PlatformEventDAOLog dao = new evt_PlatformEventDAOLog(name);
    // act
    evt_PlatformEventLogInjector ctor = new evt_PlatformEventLogInjector(dao);
    // assert
    system.assertEquals(true, ctor.m_entries.size() == 1);
  }
  @isTest
  static void testCtorevt_PlatformEventLogInjectorWithNull() {
    // assign
    // act
    evt_PlatformEventLogInjector ctor = new evt_PlatformEventLogInjector((evt_PlatformEventDAOLog)null);
    // assert
    system.assertEquals(true, ctor.m_entries.size() == 0);
  }
  @isTest
  static void testCtorevt_PlatformEventLogInjectorList() {
    // assign
    String name = 'logInfo';
    List<evt_PlatformEventDAOLog> daolist = new List<evt_PlatformEventDAOLog> {
      new evt_PlatformEventDAOLog(name)
    };
    // act
    evt_PlatformEventLogInjector ctor = new evt_PlatformEventLogInjector(daolist);
    // assert
    system.assertEquals(true, ctor.m_entries.size() == 1);
  }

  @isTest
  static void teststore() {
    // assign
    String name = 'logInfo';
    List<evt_PlatformEventDAOLog> daolist = new List<evt_PlatformEventDAOLog> {
      new evt_PlatformEventDAOLog(name)
    };
    // act
    evt_PlatformEventLogInjector ctor = new evt_PlatformEventLogInjector(daolist);
    Boolean result = ctor.store();
    // assert
    system.assertEquals(true, result);
  }
  @isTest
  static void testremove() {
    // assign
    String name = 'logInfo';
    List<evt_PlatformEventDAOLog> daolist = new List<evt_PlatformEventDAOLog> {
      new evt_PlatformEventDAOLog(name)
    };
    // act
    evt_PlatformEventLogInjector ctor = new evt_PlatformEventLogInjector(daolist);
    Boolean result = ctor.remove();
    // assert
    system.assertEquals(true, result);
  }

  @isTest
  static void testGetHandler() {
    // assign
    String name = 'logInfo';
    List<evt_PlatformEventDAOLog> daolist = new List<evt_PlatformEventDAOLog> {
      new evt_PlatformEventDAOLog(name)
    };
    // act
    evt_PlatformEventLogInjector ctor = new evt_PlatformEventLogInjector(daolist);
    evt_PlatformEventLogDataQueueHandler handler = ctor.getHandler(false);
    // assert
    system.assertEquals(true, handler != null);
  }
}
