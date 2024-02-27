import { Injectable } from '@angular/core';

import { Observable } from 'rxjs';
import { HttpClient } from '@angular/common/http';
import { AstecaMotivoModel } from '../models/AstecaMotivoModel';
import { environment } from 'src/environments/environment';


@Injectable({
  providedIn: 'root'
})
export class AstecaMotivoService {

  public astecamotivo: AstecaMotivoModel[] = [];

  constructor(private httpClient: HttpClient) { }
  
  public get(idx: number): Observable<any>{
    
    return this.httpClient.get(`${environment.url}/astecamotivo/${idx}`);
  
  }

  public list(): Observable<any>{
    
    return this.httpClient.get(`${environment.url}/astecamotivo/`);

  }

}
