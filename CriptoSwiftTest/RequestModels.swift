//
//  RequestModels.swift
//  CriptoSwiftTest
//
//  Created by QACG MAC2 on 12/29/16.
//  Copyright © 2016 QACG MAC2. All rights reserved.
//

import Foundation
/*
 private Integer userId;
	private Integer empresaId;
	private String estatusId;
	private String fechaInicial;
	private String fechaFinal;
	private Integer folio;
	private Integer ultact;
	private String mensaje;
 */
final class GestorRequest {

    func createRequestJson(request: ParametrosZMX) ->  NSDictionary {
        let json: [String: Any?] = [USUARIO: request.usuario ,CONTRASENA: request.contrasena, USERID: request.userId, EMPRESAID:request.empresaId,ESTATUSID: request.estatusId, FECHAINICIAL: request.fechaInicial , FECHAFINAL: request.fechaFinal]
        return json as NSDictionary
    }

}
