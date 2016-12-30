//
//  Models.swift
//  CriptoSwiftTest
//
//  Created by QACG MAC2 on 12/29/16.
//  Copyright © 2016 QACG MAC2. All rights reserved.
//

import Foundation
struct ParametrosZMX {
    var usuario: String = ""
    var contrasena: String = ""
    var userId: Int = 0
    var empresaId: Int = 0
    var estatusId: String = ""
    var fechaInicial: String = ""
    var fechaFinal: String = ""
    
    init(usuario: String,
     contrasena: String,
     userId: Int,
     empresaId: Int,
     estatusId: String,
     fechaInicial: String,
     fechaFinal: String) {
        self.usuario = usuario
        self.contrasena =  contrasena
         self.userId = userId
         self.empresaId = empresaId
         self.estatusId = estatusId
         self.fechaInicial =  fechaInicial
         self.fechaFinal = fechaFinal
    }
    
}


	
