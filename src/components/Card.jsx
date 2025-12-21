import React from 'react';

export default function Card({ title, value }) {
    return (
        <div style={{
            background: '#fff',
            padding: '20px',
            borderRadius: '8px',
            boxShadow: '0 2px 5px rgba(0,0,0,0.1)',
            flex: 1,
            textAlign: 'center'
        }}>
            <h3>{title}</h3>
            <p style={{ fontSize: '24px', fontWeight: 'bold' }}>{value}</p>
        </div>
    );
}
