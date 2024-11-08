package main

import (
	"fmt"
	"net"
	"strconv"
	"strings"
	"sync"
)

type Client struct {
	id   int
	conn net.Conn
	x, y int
}

var (
	clients   = make(map[int]*Client)
	clientID  = 1
	mu        sync.Mutex
	moveQueue = make(chan *Client) // Channel to queue movements
)

func main() {
	ln, err := net.Listen("tcp", "0.0.0.0:8080")
	if err != nil {
		fmt.Println("Error starting server:", err)
		return
	}
	defer ln.Close()
	fmt.Println("Server started on :8080")

	// Start a goroutine to handle movement broadcasting
	go broadcastMovements()

	for {
		conn, err := ln.Accept()
		if err != nil {
			fmt.Println("Error accepting client:", err)
			continue
		}
		go handleClient(conn)
	}
}

func handleClient(conn net.Conn) {
	defer conn.Close()

	// Assign a unique client ID and initial position
	mu.Lock()
	id := clientID
	clientID++
	client := &Client{id: id, conn: conn, x: 400, y: 300}
	clients[id] = client
	mu.Unlock()

	fmt.Printf("Client %d connected\n", id)

	// Continuously read client data
	for {
		buf := make([]byte, 1024)
		n, err := conn.Read(buf)
		if err != nil {
			break
		}

		moveData := string(buf[:n])
		coords := strings.Split(strings.TrimSpace(moveData), ",")
		if len(coords) == 2 {
			client.x, _ = strconv.Atoi(coords[0])
			client.y, _ = strconv.Atoi(coords[1])

			// Queue the client for movement broadcast
			moveQueue <- client
		}
	}

	// Cleanup on disconnect
	mu.Lock()
	delete(clients, id)
	mu.Unlock()
	fmt.Printf("Client %d disconnected\n", id)
}

func broadcastMovements() {
	for client := range moveQueue {
		mu.Lock()
		for _, otherClient := range clients {
			// Send only the updated client’s position
			message := fmt.Sprintf("%d:%d,%d\n", client.id, client.x, client.y)
			otherClient.conn.Write([]byte(message))
		}
		mu.Unlock()
	}
}
