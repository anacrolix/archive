#include "chatsocket.h"

#include <QTcpSocket>

ChatSocket::ChatSocket(QTcpSocket* socket) 
	: QObject(socket),
		m_socket(socket),
		m_pendingNewMessage(true)
{
	connect(socket, SIGNAL(readyRead()), this, SLOT(readyRead()));
	connect(socket, SIGNAL(disconnected()), this, SLOT(disconnected()));
}

void ChatSocket::sendMessage(QByteArray &msg)
{
	qint64 size = msg.size();
	m_socket->write((char*)&size, sizeof size);
	m_socket->write(msg);
}

void ChatSocket::readyRead()
{
	if (m_pendingNewMessage)
	{
		if (m_socket->peek(NULL, sizeof m_messageSize) == sizeof m_messageSize)
		{
			m_socket->read((char*)&m_messageSize, sizeof m_messageSize);
			m_pendingNewMessage = false;
			m_messageData.clear();
		}
	} 
	else 
	{
		QByteArray newData;
		newData = m_socket->read(m_messageSize-m_messageData.size());
		m_messageData.append(newData);
		if (m_messageData.size() == m_messageSize)
		{
			emit newMessage(m_socket, m_messageData);
		}
	}
}

void ChatSocket::disconnected()
{
	emit endConnection(m_socket);
}

