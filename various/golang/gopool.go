package main

import "sync"

type Manager struct {
	lock    sync.Mutex
	running uint
	waiting uint
	wakeup  chan bool
}

func (m *Manager) Go(fn func()) {
	m.lock.Lock()
	m.running++
	m.lock.Unlock()
	go func() {
		fn()
		defer func() {
			m.lock.Lock()
			m.running--
			if m.running == 0 && m.waiting > 0 {
				for ; m.waiting > 0; m.waiting-- {
					m.wakeup <- true
				}
				m.wakeup = nil
			}
			m.lock.Unlock()
		}()
	}()
}

func (m *Manager) Wait() {
	wait := false
	m.lock.Lock()
	if m.wakeup == nil {
		m.wakeup = make(chan bool)
	}
	c := m.wakeup
	if m.running > 0 {
		m.waiting++
		wait = true
	}
	m.lock.Unlock()
	if wait {
		<-c
	}
}
